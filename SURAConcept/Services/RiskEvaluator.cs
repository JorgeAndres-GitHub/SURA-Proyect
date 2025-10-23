using SURAConcept.Models;

namespace SURAConcept.Services
{
    public class RiskEvaluator
    {
        public RiskResult CalculateRisk(ClientData client)
        {
            double score = 0;

            // Edad
            if (client.Age < 25) score += 30;
            else if (client.Age > 60) score += 20;

            // Tipo de seguro
            score += client.InsuranceType.ToLower() switch
            {
                "salud" => 10,
                "vida" => 20,
                "vehicular" => 15,
                _ => 5
            };

            // Historial de reclamaciones
            score += client.ClaimsCount * 10;

            string level = score switch
            {
                < 25 => "Bajo",
                < 50 => "Medio",
                _ => "Alto"
            };

            return new RiskResult
            {
                ClientName = client.Name,
                RiskLevel = level,
                Score = score
            };
        }
    }
}
