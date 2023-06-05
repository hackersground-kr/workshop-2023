using Microsoft.AspNetCore.Rewrite;
using Microsoft.OpenApi.Models;

using WebApi.Configurations;
using WebApi.Services;

var builder = WebApplication.CreateBuilder(args);

var authSettings = new AuthSettings();
builder.Configuration.GetSection(AuthSettings.Name).Bind(authSettings);
builder.Services.AddSingleton(authSettings);

var openApiSettings = new OpenApiSettings();
builder.Configuration.GetSection(OpenApiSettings.Name).Bind(openApiSettings);
builder.Services.AddSingleton(openApiSettings);

var gitHubSettings = new GitHubSettings();
builder.Configuration.GetSection(GitHubSettings.Name).Bind(gitHubSettings);
builder.Services.AddSingleton(gitHubSettings);

builder.Services.AddScoped<IValidationService, ValidationService>();
builder.Services.AddScoped<IGitHubService, GitHubService>();

// Add services to the container.
builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(option =>
{
    option.SwaggerDoc(openApiSettings.Version, new OpenApiInfo { Title = openApiSettings.Title, Version = openApiSettings.Version });
    option.AddServer(new OpenApiServer() { Url = openApiSettings.Server });

    var gitHubSecuritySchemeReference = new OpenApiReference
    {
        Id = "github_token",
        Type = ReferenceType.SecurityScheme
    };
    var gitHubSecurityScheme = new OpenApiSecurityScheme
    {
        Name = "x-github-token",
        Description = "Please enter valid GitHub Token",
        Type = SecuritySchemeType.ApiKey,
        In = ParameterLocation.Header,
        Reference = gitHubSecuritySchemeReference
    };
    option.AddSecurityDefinition(gitHubSecuritySchemeReference.Id, gitHubSecurityScheme);
    var gitHubSecurityRequirement = new OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = gitHubSecuritySchemeReference
            },
            new string[]{}
        }
    };
    option.AddSecurityRequirement(gitHubSecurityRequirement);

    // Add global API Key security requirement
    var webApiKeySecuritySchemeReference = new OpenApiReference
    {
        Id = "api_key",
        Type = ReferenceType.SecurityScheme
    };
    var webApiKeySecurityScheme = new OpenApiSecurityScheme
    {
        Name = "x-webapi-key",
        Description = "Please enter valid API Key",
        Type = SecuritySchemeType.ApiKey,
        In = ParameterLocation.Header,
        Reference = webApiKeySecuritySchemeReference
    };
    option.AddSecurityDefinition(webApiKeySecuritySchemeReference.Id, webApiKeySecurityScheme);
    var webApiKeySecurityRequirement = new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = webApiKeySecuritySchemeReference
            },
            new string[]{}
        }
    };
    option.AddSecurityRequirement(webApiKeySecurityRequirement);
});

builder.Services.AddHttpClient();

var app = builder.Build();

//Configure the HTTP request pipeline.
//if (app.Environment.IsDevelopment())
if (openApiSettings.IncludeOnDeployment == true)
{
    app.UseSwagger();
    app.UseSwaggerUI();

    // add a new rewrite option to redirect the root to /swagger
    app.UseRewriter(new RewriteOptions().AddRedirect("^$", "swagger"));
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();