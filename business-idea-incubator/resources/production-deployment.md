# Production Deployment

This resource covers **Production Deployment** — taking a working prototype and deploying it reliably to production with monitoring, security, and scalability.

## Key Frameworks

- **12-Factor App** — Modern cloud-native application principles
- **Infrastructure as Code** — Terraform, Pulumi, CloudFormation for reproducible deployments
- **CI/CD Pipelines** — GitHub Actions, GitLab CI, CircleCI for automated testing and deployment
- **Monitoring & Observability** — Metrics (Prometheus), logs (ELK), tracing (OpenTelemetry)
- **Security Hardening** — HTTPS, CSP, rate limiting, secrets management, dependency scanning

## Common Pitfalls

- **Deploying before testing** — "It works on my machine" doesn't mean it works in production
- **No rollback plan** — One bad deploy takes down the whole site
- **Ignoring environment parity** — Dev ≠ staging ≠ production; surprises happen
- **Hardcoded secrets** — API keys in code that get committed to Git
- **No monitoring** — You don't know it's broken until customers complain

## Recommended Claude Skills

| Skill | Why It Helps |
|-------|-------------|
| `optimise-agentic-coding` | Configure MCP servers, agent workflows, and structured logging for production readiness |
| `ai-era-vulnerability-scanner` | Scan your deployed app for security vulnerabilities: supply chain risks, CI/CD misconfigs, secrets sprawl |
| `build_wordpress_plugin` | If deploying a WordPress product, ensure it's .org-compliant and production-ready |

## Output Templates

### Deployment Checklist Template

```
# Production Deployment: {{IDEA_NAME}}

## Pre-Deployment
- [ ] All tests passing (unit, integration, e2e)
- [ ] Environment variables configured (no hardcoded secrets)
- [ ] Database migrations tested
- [ ] SSL/TLS certificate ready
- [ ] Domain DNS configured
- [ ] CDN configured (if applicable)

## Deployment Steps
1. [Step 1: e.g., Build Docker image]
2. [Step 2: Push to registry]
3. [Step 3: Run database migrations]
4. [Step 4: Deploy to production]
5. [Step 5: Run smoke tests]

## Post-Deployment
- [ ] Smoke tests passing
- [ ] Monitoring dashboards active
- [ ] Error tracking configured (Sentry, etc.)
- [ ] Uptime monitoring enabled
- [ ] Rollback plan documented

## Security Checklist
- [ ] HTTPS enforced
- [ ] Security headers configured (CSP, HSTS, X-Frame-Options)
- [ ] Dependencies scanned for vulnerabilities
- [ ] Authentication/authorization tested
- [ ] Rate limiting configured
```

### Hosting Options

| Platform | Best For | Complexity | Cost |
|----------|----------|------------|------|
| Vercel / Netlify | Frontend, Next.js, static sites | Low | Free–$99/mo |
| Railway / Render | Full-stack apps, databases | Low-Medium | Free–$200/mo |
| AWS / GCP / Azure | Scale, enterprise | High | Pay-as-you-go |
| DigitalOcean / Linode | Simple VPS | Medium | $4–$80/mo |
| WordPress.com / Kinsta | WordPress products | Low | $25–$500/mo |
