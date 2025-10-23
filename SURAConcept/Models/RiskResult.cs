namespace SURAConcept.Models
{
    public class RiskResult
    {
        public string ClientName { get; set; } = string.Empty;
        public string RiskLevel { get; set; } = string.Empty;
        public double Score { get; set; }
    }
}
