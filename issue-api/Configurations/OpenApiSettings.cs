namespace WebApi.Configurations
{
    public class OpenApiSettings
    {
        public const string Name = "OpenApi";

        public virtual string? Title { get; set; }
        public virtual string? Version { get; set; }
        public virtual string? Server { get; set; }
        public virtual bool IncludeOnDeployment { get; set; }
    }
}