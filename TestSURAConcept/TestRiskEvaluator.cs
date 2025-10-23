using SURAConcept.Models;
using SURAConcept.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestSURAConcept
{
    public class TestRiskEvaluator
    {
        private readonly RiskEvaluator _riskEvaluator;

        public TestRiskEvaluator()
        {
            _riskEvaluator = new RiskEvaluator();
        }

        [Fact]
        public void CalculateRisk_YoungClientWithClaims_ReturnsHighRisk()
        {
            // Arrange
            var client = new ClientData
            {
                Name = "Juan Pérez",
                Age = 20,
                InsuranceType = "vida",
                ClaimsCount = 3
            };

            // Act
            var result = _riskEvaluator.CalculateRisk(client);

            // Assert
            Assert.Equal("Juan Pérez", result.ClientName);
            Assert.Equal(80, result.Score); // 30 (edad) + 20 (vida) + 30 (3 reclamos)
            Assert.Equal("Alto", result.RiskLevel);
        }

        [Fact]
        public void CalculateRisk_MiddleAgeClientNoClaims_ReturnsLowRisk()
        {
            // Arrange
            var client = new ClientData
            {
                Name = "María García",
                Age = 35,
                InsuranceType = "salud",
                ClaimsCount = 0
            };

            // Act
            var result = _riskEvaluator.CalculateRisk(client);

            // Assert
            Assert.Equal(10, result.Score); // 0 (edad) + 10 (salud) + 0 (reclamos)
            Assert.Equal("Bajo", result.RiskLevel);
        }

        [Fact]
        public void CalculateRisk_SeniorWithVehicleInsurance_ReturnsMediumRisk()
        {
            // Arrange
            var client = new ClientData
            {
                Name = "Carlos López",
                Age = 65,
                InsuranceType = "vehicular",
                ClaimsCount = 1
            };

            // Act
            var result = _riskEvaluator.CalculateRisk(client);

            // Assert
            Assert.Equal(45, result.Score); // 20 (edad) + 15 (vehicular) + 10 (1 reclamo)
            Assert.Equal("Medio", result.RiskLevel);
        }
    }
}
