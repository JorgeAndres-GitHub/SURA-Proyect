using Microsoft.AspNetCore.Mvc;
using SURAConcept.Controllers;
using SURAConcept.Models;
using SURAConcept.Services;

namespace TestSURAConcept
{
    public class RiskEvaluationControllerTests
    {
        private readonly RiskEvaluationController _controller;

        public RiskEvaluationControllerTests()
        {
            _controller = new RiskEvaluationController(new RiskEvaluator());
        }

        [Fact]
        public void EvaluateRisk_ReturnsBadRequest_WhenClientIsNull()
        {
            var result = _controller.EvaluateRisk(null);
            Assert.IsType<BadRequestObjectResult>(result.Result);
        }

        [Fact]
        public void EvaluateRisk_ReturnsLowRisk_ForSafeClient()
        {
            var client = new ClientData
            {
                Name = "Ana Pérez",
                Age = 35,
                InsuranceType = "Salud",
                ClaimsCount = 0
            };

            var result = _controller.EvaluateRisk(client).Result as OkObjectResult;
            var value = Assert.IsType<RiskResult>(result.Value);

            Assert.Equal("Bajo", value.RiskLevel);
        }

        [Fact]
        public void EvaluateRisk_ReturnsHighRisk_ForManyClaims()
        {
            var client = new ClientData
            {
                Name = "Carlos Gómez",
                Age = 45,
                InsuranceType = "Vida",
                ClaimsCount = 3
            };

            var result = _controller.EvaluateRisk(client).Result as OkObjectResult;
            var value = Assert.IsType<RiskResult>(result.Value);

            Assert.Equal("Alto", value.RiskLevel);
        }
    }
}
