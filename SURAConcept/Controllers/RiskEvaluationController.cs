using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SURAConcept.Models;
using SURAConcept.Services;

namespace SURAConcept.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RiskEvaluationController : ControllerBase
    {
        private readonly RiskEvaluator _evaluator;

        public RiskEvaluationController(RiskEvaluator evaluator)
        {
            _evaluator = evaluator;
        }

        [HttpPost("evaluate")]
        public ActionResult<RiskResult> EvaluateRisk([FromBody] ClientData client)
        {
            if (client == null)
                return BadRequest("Los datos del cliente son necesarios.");

            var result = _evaluator.CalculateRisk(client);
            return Ok(result);
        }
    }
}
