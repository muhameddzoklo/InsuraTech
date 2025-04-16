﻿// <auto-generated />
using System;
using InsuraTech.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

#nullable disable

namespace InsuraTech.Services.Migrations
{
    [DbContext(typeof(InsuraTechContext))]
    partial class InsuraTechContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "9.0.3")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("InsuraTech.Services.Database.ClaimRequest", b =>
                {
                    b.Property<int>("ClaimRequestId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("ClaimRequestId"));

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<string>("Description")
                        .HasColumnType("nvarchar(max)");

                    b.Property<decimal?>("EstimatedAmount")
                        .HasColumnType("decimal(18,2)");

                    b.Property<int>("InsurancePolicyId")
                        .HasColumnType("int");

                    b.Property<int?>("InsurancePolicyId1")
                        .HasColumnType("int");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("Status")
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime?>("SubmittedAt")
                        .HasColumnType("datetime2");

                    b.HasKey("ClaimRequestId");

                    b.HasIndex("InsurancePolicyId");

                    b.HasIndex("InsurancePolicyId1");

                    b.ToTable("ClaimRequests");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.Client", b =>
                {
                    b.Property<int>("ClientId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("ClientId"));

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("FirstName")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("LastName")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.Property<string>("PasswordHash")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PasswordSalt")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PhoneNumber")
                        .HasColumnType("nvarchar(max)");

                    b.Property<byte[]>("ProfilePicture")
                        .HasColumnType("varbinary(max)");

                    b.Property<DateTime>("RegistrationDate")
                        .HasColumnType("datetime2");

                    b.Property<string>("Username")
                        .IsRequired()
                        .HasMaxLength(100)
                        .HasColumnType("nvarchar(100)");

                    b.HasKey("ClientId");

                    b.ToTable("Clients");

                    b.HasData(
                        new
                        {
                            ClientId = 1,
                            Email = "client@mail.com",
                            FirstName = "Client",
                            IsDeleted = false,
                            LastName = "Client",
                            PasswordHash = "uRq1YqSB0lg3cdpu9nd/KzSRItM=",
                            PasswordSalt = "hJAv+NlOCMXaoDXa+MPk9A==",
                            PhoneNumber = "000000003",
                            RegistrationDate = new DateTime(2025, 4, 16, 22, 52, 3, 0, DateTimeKind.Unspecified),
                            Username = "client"
                        },
                        new
                        {
                            ClientId = 2,
                            Email = "client1@mail.com",
                            FirstName = "Client1",
                            IsDeleted = false,
                            LastName = "Client1",
                            PasswordHash = "tLbv6EHzaanWRumREUrlGSf2XS0=",
                            PasswordSalt = "oQ3qYpn5T8Z4n5nm5aGrvA==",
                            PhoneNumber = "000000004",
                            RegistrationDate = new DateTime(2025, 4, 16, 22, 52, 3, 0, DateTimeKind.Unspecified),
                            Username = "client1"
                        },
                        new
                        {
                            ClientId = 3,
                            Email = "client2@mail.com",
                            FirstName = "Client2",
                            IsDeleted = false,
                            LastName = "Client2",
                            PasswordHash = "8OB3D2RPgagepehex0hLz6HdM1Q=",
                            PasswordSalt = "mGr/PGoIDO5ILaJYl3MvJg==",
                            PhoneNumber = "000000005",
                            RegistrationDate = new DateTime(2025, 4, 16, 22, 52, 3, 0, DateTimeKind.Unspecified),
                            Username = "client2"
                        });
                });

            modelBuilder.Entity("InsuraTech.Services.Database.CustomerFeedback", b =>
                {
                    b.Property<int>("CustomerFeedbackId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("CustomerFeedbackId"));

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<int?>("Rating")
                        .HasColumnType("int");

                    b.Property<DateTime?>("SubmittedAt")
                        .HasColumnType("datetime2");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("CustomerFeedbackId");

                    b.HasIndex("UserId");

                    b.ToTable("CustomerFeedbacks");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.InsurancePackage", b =>
                {
                    b.Property<int>("InsurancePackageId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("InsurancePackageId"));

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<string>("Description")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("Name")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<byte[]>("Picture")
                        .HasColumnType("varbinary(max)");

                    b.Property<decimal>("Price")
                        .HasColumnType("decimal(18,2)");

                    b.HasKey("InsurancePackageId");

                    b.ToTable("InsurancePackages");

                    b.HasData(
                        new
                        {
                            InsurancePackageId = 1,
                            Description = "Essential coverage for your vehicle, including third-party liability and collision coverage.",
                            IsDeleted = false,
                            Name = "Basic Car Insurance",
                            Price = 199.99m
                        },
                        new
                        {
                            InsurancePackageId = 2,
                            Description = "Extensive protection for your home covering fire, theft, natural disasters, and personal liability.",
                            IsDeleted = false,
                            Name = "Comprehensive Home Insurance",
                            Price = 349.50m
                        },
                        new
                        {
                            InsurancePackageId = 3,
                            Description = "Premium medical coverage offering extensive benefits including hospitalization, dental care, and vision care.",
                            IsDeleted = false,
                            Name = "Premium Health Insurance",
                            Price = 499.00m
                        });
                });

            modelBuilder.Entity("InsuraTech.Services.Database.InsurancePackageClaim", b =>
                {
                    b.Property<int>("InsurancePackageClaimId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("InsurancePackageClaimId"));

                    b.Property<decimal?>("ClaimAmount")
                        .HasColumnType("decimal(18,2)");

                    b.Property<DateTime?>("ClaimDate")
                        .HasColumnType("datetime2");

                    b.Property<int>("ClaimRequestId")
                        .HasColumnType("int");

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<int>("InsurancePackageId")
                        .HasColumnType("int");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.HasKey("InsurancePackageClaimId");

                    b.HasIndex("ClaimRequestId");

                    b.HasIndex("InsurancePackageId");

                    b.ToTable("InsurancePackageClaims");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.InsurancePolicy", b =>
                {
                    b.Property<int>("InsurancePolicyId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("InsurancePolicyId"));

                    b.Property<int>("ClientId")
                        .HasColumnType("int");

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<DateTime>("EndDate")
                        .HasColumnType("datetime2");

                    b.Property<int>("InsurancePackageId")
                        .HasColumnType("int");

                    b.Property<int?>("InsurancePackageId1")
                        .HasColumnType("int");

                    b.Property<bool>("IsActive")
                        .HasColumnType("bit");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<DateTime>("StartDate")
                        .HasColumnType("datetime2");

                    b.HasKey("InsurancePolicyId");

                    b.HasIndex("ClientId");

                    b.HasIndex("InsurancePackageId");

                    b.HasIndex("InsurancePackageId1");

                    b.ToTable("InsurancePolicies");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.MessageLog", b =>
                {
                    b.Property<int>("MessageLogId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("MessageLogId"));

                    b.Property<string>("Content")
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<DateTime?>("SentAt")
                        .HasColumnType("datetime2");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("MessageLogId");

                    b.HasIndex("UserId");

                    b.ToTable("MessageLogs");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.Notification", b =>
                {
                    b.Property<int>("NotificationId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("NotificationId"));

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<bool?>("IsRead")
                        .HasColumnType("bit");

                    b.Property<string>("Message")
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime?>("SentAt")
                        .HasColumnType("datetime2");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("NotificationId");

                    b.HasIndex("UserId");

                    b.ToTable("Notifications");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.PaymentMethod", b =>
                {
                    b.Property<int>("PaymentMethodId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("PaymentMethodId"));

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("MethodName")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("PaymentMethodId");

                    b.ToTable("PaymentMethods");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.Role", b =>
                {
                    b.Property<int>("RoleId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("RoleId"));

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<string>("Description")
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("RoleName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("RoleId");

                    b.ToTable("Roles");

                    b.HasData(
                        new
                        {
                            RoleId = 1,
                            Description = "Administrator with full access to settings, user permissions and platform operations.",
                            IsDeleted = false,
                            RoleName = "Admin"
                        },
                        new
                        {
                            RoleId = 2,
                            Description = "An Insurance Agent manages policies, processes claims, and assists customers with recommendations and approvals.",
                            IsDeleted = false,
                            RoleName = "Agent"
                        },
                        new
                        {
                            RoleId = 3,
                            Description = "Supports insurance agents by handling administrative tasks, managing client inquiries, and processing policy updates",
                            IsDeleted = false,
                            RoleName = "Assistant"
                        });
                });

            modelBuilder.Entity("InsuraTech.Services.Database.Transaction", b =>
                {
                    b.Property<int>("TransactionId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("TransactionId"));

                    b.Property<decimal?>("Amount")
                        .HasColumnType("decimal(18,2)");

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<int>("PaymentMethodId")
                        .HasColumnType("int");

                    b.Property<DateTime?>("Timestamp")
                        .HasColumnType("datetime2");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("TransactionId");

                    b.HasIndex("PaymentMethodId");

                    b.HasIndex("UserId");

                    b.ToTable("Transactions");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.User", b =>
                {
                    b.Property<int>("UserId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("UserId"));

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<string>("Email")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("FirstName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<string>("LastName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PasswordHash")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PasswordSalt")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PhoneNumber")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Username")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("UserId");

                    b.ToTable("Users");

                    b.HasData(
                        new
                        {
                            UserId = 1,
                            Email = "1",
                            FirstName = "1",
                            IsDeleted = false,
                            LastName = "1",
                            PasswordHash = "XVDI7NKoOCtMiSrKR1uSSGWvA7o=",
                            PasswordSalt = "NHVv+8KhAiQqFlz7k1P53Q==",
                            PhoneNumber = "1",
                            Username = "1"
                        },
                        new
                        {
                            UserId = 2,
                            Email = "admin@mail.com",
                            FirstName = "Admin",
                            IsDeleted = false,
                            LastName = "Admin",
                            PasswordHash = "+zHjeAMut/qVPctS7uaREf4lN1w=",
                            PasswordSalt = "sOQz4gFWKGh9SeOhqXpqyw==",
                            PhoneNumber = "000000000",
                            Username = "admin"
                        },
                        new
                        {
                            UserId = 3,
                            Email = "agent@mail.com",
                            FirstName = "Agent",
                            IsDeleted = false,
                            LastName = "Agent",
                            PasswordHash = "9hkvRabWkVOkr+Hqr52lzoMKiKo=",
                            PasswordSalt = "2ICZgybWHKj+fYpTc6/19g==",
                            PhoneNumber = "000000001",
                            Username = "agent"
                        },
                        new
                        {
                            UserId = 4,
                            Email = "assistant@mail.com",
                            FirstName = "Assistant",
                            IsDeleted = false,
                            LastName = "Assistant",
                            PasswordHash = "sfrZuf7hqepHmMV6gt83a/RaB9g=",
                            PasswordSalt = "Ct53DBogAC4vUxlb2WodgQ==",
                            PhoneNumber = "000000002",
                            Username = "assistant"
                        });
                });

            modelBuilder.Entity("InsuraTech.Services.Database.UserFeedback", b =>
                {
                    b.Property<int>("UserFeedbackId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("UserFeedbackId"));

                    b.Property<int>("CustomerFeedbackId")
                        .HasColumnType("int");

                    b.Property<int?>("CustomerFeedbackId1")
                        .HasColumnType("int");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("UserFeedbackId");

                    b.HasIndex("CustomerFeedbackId");

                    b.HasIndex("CustomerFeedbackId1");

                    b.HasIndex("UserId");

                    b.ToTable("UserFeedbacks");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.UserRole", b =>
                {
                    b.Property<int>("UserRoleId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("UserRoleId"));

                    b.Property<DateTime>("ChangeDate")
                        .HasColumnType("datetime2");

                    b.Property<DateTime?>("DeletionTime")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsDeleted")
                        .HasColumnType("bit");

                    b.Property<int>("RoleId")
                        .HasColumnType("int");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("UserRoleId");

                    b.HasIndex("RoleId");

                    b.HasIndex("UserId");

                    b.ToTable("UserRoles");

                    b.HasData(
                        new
                        {
                            UserRoleId = 1,
                            ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified),
                            IsDeleted = false,
                            RoleId = 1,
                            UserId = 1
                        },
                        new
                        {
                            UserRoleId = 2,
                            ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified),
                            IsDeleted = false,
                            RoleId = 1,
                            UserId = 2
                        },
                        new
                        {
                            UserRoleId = 3,
                            ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified),
                            IsDeleted = false,
                            RoleId = 2,
                            UserId = 3
                        },
                        new
                        {
                            UserRoleId = 4,
                            ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified),
                            IsDeleted = false,
                            RoleId = 3,
                            UserId = 4
                        });
                });

            modelBuilder.Entity("InsuraTech.Services.Database.ClaimRequest", b =>
                {
                    b.HasOne("InsuraTech.Services.Database.InsurancePolicy", "insurancePolicy")
                        .WithMany()
                        .HasForeignKey("InsurancePolicyId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.HasOne("InsuraTech.Services.Database.InsurancePolicy", null)
                        .WithMany("ClaimRequests")
                        .HasForeignKey("InsurancePolicyId1");

                    b.Navigation("insurancePolicy");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.CustomerFeedback", b =>
                {
                    b.HasOne("InsuraTech.Services.Database.User", "User")
                        .WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("User");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.InsurancePackageClaim", b =>
                {
                    b.HasOne("InsuraTech.Services.Database.ClaimRequest", "ClaimRequest")
                        .WithMany()
                        .HasForeignKey("ClaimRequestId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.HasOne("InsuraTech.Services.Database.InsurancePackage", "InsurancePackage")
                        .WithMany()
                        .HasForeignKey("InsurancePackageId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("ClaimRequest");

                    b.Navigation("InsurancePackage");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.InsurancePolicy", b =>
                {
                    b.HasOne("InsuraTech.Services.Database.Client", "Client")
                        .WithMany()
                        .HasForeignKey("ClientId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.HasOne("InsuraTech.Services.Database.InsurancePackage", "InsurancePackage")
                        .WithMany()
                        .HasForeignKey("InsurancePackageId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.HasOne("InsuraTech.Services.Database.InsurancePackage", null)
                        .WithMany("Policies")
                        .HasForeignKey("InsurancePackageId1");

                    b.Navigation("Client");

                    b.Navigation("InsurancePackage");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.MessageLog", b =>
                {
                    b.HasOne("InsuraTech.Services.Database.User", "User")
                        .WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("User");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.Notification", b =>
                {
                    b.HasOne("InsuraTech.Services.Database.User", "User")
                        .WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("User");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.Transaction", b =>
                {
                    b.HasOne("InsuraTech.Services.Database.PaymentMethod", "paymentMethod")
                        .WithMany()
                        .HasForeignKey("PaymentMethodId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.HasOne("InsuraTech.Services.Database.User", "User")
                        .WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("User");

                    b.Navigation("paymentMethod");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.UserFeedback", b =>
                {
                    b.HasOne("InsuraTech.Services.Database.CustomerFeedback", "CustomerFeedback")
                        .WithMany()
                        .HasForeignKey("CustomerFeedbackId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.HasOne("InsuraTech.Services.Database.CustomerFeedback", null)
                        .WithMany("UserFeedbacks")
                        .HasForeignKey("CustomerFeedbackId1");

                    b.HasOne("InsuraTech.Services.Database.User", "User")
                        .WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Restrict)
                        .IsRequired();

                    b.Navigation("CustomerFeedback");

                    b.Navigation("User");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.UserRole", b =>
                {
                    b.HasOne("InsuraTech.Services.Database.Role", "Role")
                        .WithMany("UserRoles")
                        .HasForeignKey("RoleId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("InsuraTech.Services.Database.User", "User")
                        .WithMany("UserRoles")
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Role");

                    b.Navigation("User");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.CustomerFeedback", b =>
                {
                    b.Navigation("UserFeedbacks");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.InsurancePackage", b =>
                {
                    b.Navigation("Policies");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.InsurancePolicy", b =>
                {
                    b.Navigation("ClaimRequests");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.Role", b =>
                {
                    b.Navigation("UserRoles");
                });

            modelBuilder.Entity("InsuraTech.Services.Database.User", b =>
                {
                    b.Navigation("UserRoles");
                });
#pragma warning restore 612, 618
        }
    }
}
