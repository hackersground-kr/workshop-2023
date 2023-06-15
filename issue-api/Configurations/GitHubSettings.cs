namespace WebApi.Configurations
{
    public class GitHubSettings
    {
        public const string Name = "GitHub";

        public virtual string? Agent { get; set; }
        public virtual string? ClientId { get; set; }
        public virtual string? ClientSecret { get; set; }
    }
}
