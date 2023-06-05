namespace WebApi.Configurations
{
    public class AuthSettings
    {
        public const string Name = "Auth";

        public virtual string? ApiKey { get; set; }
    }
}