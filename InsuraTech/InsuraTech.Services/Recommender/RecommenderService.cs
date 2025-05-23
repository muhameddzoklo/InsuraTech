using InsuraTech.Model.DTOs;
using InsuraTech.Services.Database;
using Mapster;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace InsuraTech.Services.Recommender
{
    public class RecommenderService : IRecommenderService
    {
        private readonly InsuraTechContext _context;
        private readonly IMapper _mapper;
        private static readonly MLContext mlContext = new MLContext();
        private static readonly object _lock = new object();
        private const string ModelPath = "insurance-package-model.zip";
        private static ITransformer? model = null;

        public RecommenderService(InsuraTechContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
            if (model == null)
                LoadOrTrainModel();
        }

        public class PackageData
        {
            public int InsurancePackageId { get; set; }
            public string Description { get; set; } = string.Empty;
            public float Price { get; set; }
            public float Duration { get; set; }
            public float AverageRating { get; set; }
        }

        public class PackagePrediction
        {
            [VectorType]
            public float[] Features { get; set; } = Array.Empty<float>();
        }

        public void TrainModel()
        {
            lock (_lock)
            {
                var packages = _context.InsurancePackages
                    .Include(x => x.ClientFeedbacks)
                    .Where(x => x.StateMachine == "active" && !x.IsDeleted)
                    .ToList();

                var dataList = packages.Select(p => new PackageData
                {
                    InsurancePackageId = p.InsurancePackageId,
                    Description = p.Description,
                    Price = (float)p.Price,
                    Duration = p.DurationDays,
                    AverageRating = p.ClientFeedbacks.Any() ? (float)p.ClientFeedbacks.Average(f => f.Rating) : 0f
                }).ToList();

                var data = mlContext.Data.LoadFromEnumerable(dataList);

                var pipeline = mlContext.Transforms.Text.FeaturizeText("DescriptionFeats", nameof(PackageData.Description))
                    .Append(mlContext.Transforms.Concatenate("Features", "DescriptionFeats", nameof(PackageData.Price), nameof(PackageData.Duration), nameof(PackageData.AverageRating)));

                model = pipeline.Fit(data);

                using var fs = new FileStream(ModelPath, FileMode.Create, FileAccess.Write, FileShare.Write);
                mlContext.Model.Save(model, data.Schema, fs);
            }
        }

        private void LoadOrTrainModel()
        {
            if (File.Exists(ModelPath))
            {
                using var fs = new FileStream(ModelPath, FileMode.Open, FileAccess.Read, FileShare.Read);
                model = mlContext.Model.Load(fs, out _);
            }
            else
            {
                TrainModel();
            }
        }

        public async Task<List<InsurancePackageDTO>> Recommend(int clientId)
        {
            var allPackages = await _context.InsurancePackages
                .Include(x => x.ClientFeedbacks)
                .Where(p => p.StateMachine == "active" && !p.IsDeleted)
                .ToListAsync();

            var historyPackageIds = await _context.InsurancePolicies
                .Where(p => p.ClientId == clientId)
                .Select(p => p.InsurancePackageId)
                .Distinct()
                .ToListAsync();

            var allData = allPackages.Select(p => new PackageData
            {
                InsurancePackageId = p.InsurancePackageId,
                Description = p.Description,
                Price = (float)p.Price,
                Duration = p.DurationDays,
                AverageRating = p.ClientFeedbacks.Any() ? (float)p.ClientFeedbacks.Average(f => f.Rating) : 0f
            }).ToList();

            var profileData = allData.Where(p => historyPackageIds.Contains(p.InsurancePackageId)).ToList();

            if (!profileData.Any())
            {
                return _mapper.Map<List<InsurancePackageDTO>>(
                    allPackages.OrderByDescending(p => p.ClientFeedbacks.Count).Take(5)
                );
            }

            var predictionEngine = mlContext.Model.CreatePredictionEngine<PackageData, PackagePrediction>(model);
            var profileVectors = profileData.Select(p => predictionEngine.Predict(p).Features).ToList();
            var profileVector = AverageVector(profileVectors);

            var predictions = new List<(int id, float score)>();
            foreach (var pkg in allData)
            {
                if (historyPackageIds.Contains(pkg.InsurancePackageId)) continue;
                var vector = predictionEngine.Predict(pkg).Features;
                var score = CosineSimilarity(profileVector, vector);
                predictions.Add((pkg.InsurancePackageId, score));
            }

            var recommendedIds = predictions.OrderByDescending(x => x.score).Take(3).Select(x => x.id).ToList();
            var recommended = allPackages.Where(p => recommendedIds.Contains(p.InsurancePackageId)).ToList();
            return _mapper.Map<List<InsurancePackageDTO>>(recommended);
        }

        private float[] AverageVector(List<float[]> vectors)
        {
            var length = vectors[0].Length;
            var avg = new float[length];
            foreach (var v in vectors)
                for (int i = 0; i < length; i++)
                    avg[i] += v[i];
            for (int i = 0; i < length; i++)
                avg[i] /= vectors.Count;
            return avg;
        }

        private float CosineSimilarity(float[] v1, float[] v2)
        {
            float dot = 0, mag1 = 0, mag2 = 0;
            for (int i = 0; i < v1.Length; i++)
            {
                dot += v1[i] * v2[i];
                mag1 += v1[i] * v1[i];
                mag2 += v2[i] * v2[i];
            }
            return (float)(dot / (Math.Sqrt(mag1) * Math.Sqrt(mag2)));
        }
    }
}
