// See https://aka.ms/new-console-template for more information

using System.Net.Sockets;
using DotNetEnv;
using EasyNetQ;
using InsuraTech.Model.Messages;
using InsuraTech.Subscriber.EmailService;

var envPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "../../../../.env");
Env.Load(envPath);

DotNetEnv.Env.Load(envPath);
//Console.WriteLine($"Searching for .env in: {envPath}");
//Console.WriteLine($"File exists: {File.Exists(envPath)}");

string rabbitmqport = Environment.GetEnvironmentVariable("RABBIT_MQ_PORT") ?? string.Empty;
string rabbitmqhost = Environment.GetEnvironmentVariable("RABBIT_MQ_HOST") ?? string.Empty;
Console.WriteLine($"{rabbitmqport}");
await WaitForRabbitMQAsync($"{rabbitmqhost}", int.TryParse(rabbitmqport, out var result) ? result : 0);

string smtpHost = Environment.GetEnvironmentVariable("SMTP_HOST") ?? string.Empty;
int smtpPort = int.TryParse(Environment.GetEnvironmentVariable("SMTP_PORT"), out var port) ? port : 0;
string smtpUser = Environment.GetEnvironmentVariable("SMTP_USER") ?? string.Empty;
string smtpPass = Environment.GetEnvironmentVariable("SMTP_PASS") ?? string.Empty;

string rabbitmq = Environment.GetEnvironmentVariable("RABBIT_MQ") ?? string.Empty;

var emailService = new EmailService(smtpHost, smtpPort, smtpUser, smtpPass);
var bus = RabbitHutch.CreateBus(rabbitmq);
Console.WriteLine($"{rabbitmq}");

bus.PubSub.Subscribe<AccountCreationMsg>("account_creation_subscriber", async msg =>
{
    string emailBody = $@"
                    <!DOCTYPE html>
                    <html lang='en'>
                    <head>
                        <meta charset='UTF-8'>
                        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                        <title>Welcome to InsuraTech</title>
                        <style>
                            body {{
                                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                                background-color: #f9fafc;
                                margin: 0;
                                padding: 40px 0;
                                color: #2e2e2e;
                            }}
                            .email-wrapper {{
                                max-width: 620px;
                                margin: auto;
                                background: linear-gradient(to bottom right, #ffffff, #f0f4f8);
                                border-radius: 12px;
                                overflow: hidden;
                                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
                                padding: 30px 40px;
                            }}
                            .header {{
                                background-color: #1d3557;
                                padding: 20px;
                                color: white;
                                text-align: center;
                            }}
                            .header h1 {{
                                margin: 0;
                                font-size: 24px;
                            }}
                            .content {{
                                padding: 20px 0;
                            }}
                            .credentials {{
                                background-color: #e8f4ff;
                                border: 1px solid #c2e0ff;
                                border-radius: 8px;
                                padding: 20px;
                                margin: 20px 0;
                            }}
                            .credentials p {{
                                margin: 8px 0;
                                font-size: 16px;
                            }}
                            .cta {{
                                display: inline-block;
                                margin-top: 15px;
                                background-color: #0077b6;
                                color: #ffffff;
                                padding: 10px 20px;
                                border-radius: 6px;
                                text-decoration: none;
                                font-weight: bold;
                            }}
                            .footer {{
                                text-align: center;
                                margin-top: 40px;
                                font-size: 12px;
                                color: #888;
                            }}
                        </style>
                    </head>
                    <body>
                        <div class='email-wrapper'>
                            <div class='header'>
                                <h1>Welcome, {msg.employeeFirstName}!</h1>
                            </div>
                            <div class='content'>
                                <p>Hello {msg.employeeFirstName},</p>
                                <p>Your InsuraTech account has been created successfully. Here are your login credentials:</p>
                                <div class='credentials'>
                                    <p><strong>Username:</strong> {msg.username}</p>
                                    <p><strong>Password:</strong> {msg.password}</p>
                                </div>
                                <p>We strongly recommend that you log in and change your password right away for security reasons.</p>
                                <p>If you have any questions, feel free to contact our support team.</p>
                                <p>Best regards,<br>The InsuraTech Team</p>
                            </div>
                            <div class='footer'>
                                <p>This is an automated message. Please do not reply.</p>
                            </div>
                        </div>
                    </body>
                    </html>";


    try
    {
        await emailService.SendEmailAsync(msg.email, "InsuraTech account has been created", emailBody);
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Failed to send email: {ex.Message}");
    }
});

Console.WriteLine("Listening for messages, press <return> key to close!");
Thread.Sleep(Timeout.Infinite);
Console.ReadLine();

async Task WaitForRabbitMQAsync(string host, int port, int maxRetries = 10, int delayMilliseconds = 2000)
{
    for (int i = 0; i < maxRetries; i++)
    {
        try
        {
            using (var client = new TcpClient())
            {
                await client.ConnectAsync(host, port);
                Console.WriteLine("RabbitMQ is up and running!");
                return;
            }
        }
        catch (SocketException)
        {
            Console.WriteLine($"RabbitMQ is not available yet. Retrying in {delayMilliseconds / 1000} seconds...");
            await Task.Delay(delayMilliseconds);
        }
    }

    Console.WriteLine("Failed to connect to RabbitMQ after several attempts.");
    Environment.Exit(1);
}