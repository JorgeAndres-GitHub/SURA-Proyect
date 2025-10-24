# 🧩 SURAConcept — Automatización de Calidad y Despliegue

Este proyecto implementa una arquitectura automatizada de **integración y despliegue continuo (CI/CD)** para una aplicación .NET, integrando **SonarQube, Docker y AWS ECS**, con el objetivo de garantizar la calidad del código y la eficiencia en el ciclo de vida del software.

---

## 🚀 Tecnologías principales
- **.NET 9** — Backend principal  
- **SonarQube** — Análisis estático y Quality Gates  
- **Docker & Docker Hub** — Contenerización y distribución de imágenes  
- **GitHub Actions** — Automatización de compilación, análisis y despliegue  
- **AWS ECS** — Orquestación y despliegue de contenedores  
- **Terraform** — Infraestructura como código  

---

## 🧠 Objetivo
Implementar un pipeline completamente automatizado que:  
1. Compile y analice el código fuente con SonarQube  
2. Genere y publique una imagen Docker  
3. Despliegue la aplicación en AWS ECS con Terraform  
4. Evalúe la calidad del software usando métricas basadas en **ISO/IEC 25010**

---

## 📊 Calidad del código
Los **Quality Gates** se basan en los atributos de la norma **ISO/IEC 25010**, evaluando:

- **Mantenibilidad**  
- **Confiabilidad**  
- **Seguridad**  
- **Eficiencia de desempeño**  
- **Cobertura de pruebas** (mínimo 80%)

---

## 💡 Próximos pasos
- Integrar escaneo de vulnerabilidades (Snyk / OWASP)  
- Automatizar pruebas unitarias dentro del pipeline  
- Entrenar al equipo en prácticas DevOps y uso avanzado de SonarQube  

---
