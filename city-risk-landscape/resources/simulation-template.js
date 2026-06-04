/* ============================================================================
   SIMULATION TEMPLATE - JAVASCRIPT
   Copy this file and customize the CONFIG sections for your target business
   ============================================================================ */

// ============================================================================
// CONFIG: SIMULATION PARAMETERS - Customize for target business
// ============================================================================

const params = {
    // Base attack rate from ASD Annual Cyber Threat Report 2024-25
    baseRate: 0.38,
    
    // CONFIG: Industry modifiers
    // Format: industryKey: { mod: attackModifier, dailyRate: AUD, regulatoryFine: AUD }
    // mod: 1.0 = baseline, <1 = lower risk, >1 = higher risk
    // dailyRate: Lost revenue per day of downtime (sector-specific)
    // regulatoryFine: OAIC/sector penalty for data breach ($0 if not applicable)
    industryModifiers: {
        // Health sector example:
        // health: { mod: 0.9, dailyRate: 1500, regulatoryFine: 35000 },
        
        // Accounting/Financial example:
        // accounting: { mod: 0.85, dailyRate: 1800, regulatoryFine: 35000 },
        
        // Retail example:
        // retail: { mod: 1.1, dailyRate: 800, regulatoryFine: 0 },
        
        // Restaurant example:
        // restaurant: { mod: 1.0, dailyRate: 1200, regulatoryFine: 0 },
        
        // Default fallback:
        default: { mod: 1.0, dailyRate: 1000, regulatoryFine: 0 }
    },
    
    // CONFIG: Location modifiers (attacker maturity curve)
    // Example: Perth [0.7, 0.85, 1.0, 1.0, 1.0] = Year 1: 0.7×, Year 3: 1.0×
    // Major cities: [1.0, 1.0, 1.0, 1.0, 1.0] (immediate full exposure)
    // Regional: [0.5, 0.6, 0.7, 0.85, 1.0] (slower attacker discovery)
    locationModifiers: [0.7, 0.85, 1.0, 1.0, 1.0],
    
    // Scenario multipliers (fixed - comparison baseline)
    securityMultiplier: 0.6,    // Scenario A (Status Quo)
    securityMultiplierC: 0.15, // Scenario C (Full Audit)
    
    // Online presence increases attack surface
    onlinePaymentModifier: 0.25,
    
    // Mythos-era AI attack compression (1.35× exponential per year)
    // Year 1: 1.0×, Year 2: 1.35×, Year 3: 1.82×, Year 4: 2.46×, Year 5: 3.32×
    mythosMultiplier: 1.35,
    
    // CONFIG: Default revenue for sector ($AUD)
    revenue: 250000,
    
    // Base recovery cost from Hyetech Australia
    recoveryCostBase: 97000,
    
    // Insurance parameters
    hasInsurance: false,
    insuranceOffset: 0.60,  // 60% recovery cost offset
    
    // Profit margin resilience multipliers
    profitMarginMultipliers: {
        low: 1.3,      // Low margin = 30% HIGHER failure risk (less buffer)
        medium: 1.0,   // Baseline
        high: 0.7      // High margin = 30% LOWER failure risk (more resilient)
    },
    
    // Cash reserve months by profit margin (working capital depth)
    // Low margin (5-10%): 1-2 months reserves | Medium (15-20%): 3-4 months | High (25%+): 6+ months
    cashReserveMonths: { low: 1.5, medium: 3.5, high: 6.0 },
    // Breach cash impact threshold - if breach cost exceeds this × annual profit, risk immediate insolvency
    cashFlowCatastropheThreshold: 2.0,
    
    // AI Business Efficiency: EXPONENTIAL market capture
    // 25% compound annual growth in competitive advantage
    // Year 1: +25%, Year 2: +56%, Year 3: +95%, Year 4: +144%, Year 5: +205%
    aiBusinessGrowthRate: 0.25,
    
    // Fixed staff cost savings (immediate, not time-dependent)
    staffCostReduction: 0.15,  // 15% reduction with AI tools
    
    // Reputational Damage: EXPONENTIAL viral amplification
    baseReputationalHit: 0.12,      // Initial 12% revenue loss from breach
    viralAmplification: 0.20,        // 20% compounding per year (network effects)
    
    // Assumed staff cost as % of revenue for small business
    staffCostRatio: 0.45,
    
    // Security Bundle: EXPONENTIAL effectiveness curves
    // Traditional: DECAYS rapidly as AI attacks evolve (50% lost per year) - static defenses cannot adapt
    // AI-Powered: IMPROVES as system learns (8% gained per year)
    securityBundles: {
        none: { 
            baseAttackMult: 1.0,      // No protection
            decayRate: 0.0,          // Static - nothing to decay
            recoveryTimeMult: 2.0,    // 2× longer recovery
            survivalImprovement: 0.0,
            dwellTimeReduction: 0.0
        },
        traditional: { 
            baseAttackMult: 0.25,     // 75% attack reduction initially - but decays rapidly
            decayRate: 0.50,         // 50% effectiveness LOST per year to AI attacks - OBSOLETE by Year 5
            recoveryTimeMult: 0.6,    // 40% faster recovery with tested backups
            survivalImprovement: 0.15, // +15% survival from training + tested recovery
            dwellTimeReduction: 0.0
        },
        'ai-powered': { 
            baseAttackMult: 0.06,     // 94% attack reduction initially
            decayRate: -0.08,        // NEGATIVE = 8% effectiveness GAIN per year (AI learns)
            recoveryTimeMult: 0.3,    // 70% faster recovery with air-gapped + AI response
            survivalImprovement: 0.35, // +35% survival with IR confidence
            dwellTimeReduction: 0.50   // 50% dwell time reduction via AI detection
        }
    }
};

// ============================================================================
// CORE CALCULATION FUNCTIONS - DO NOT MODIFY
// ============================================================================

let survivalChart, attackChart, financialChart, cumulativeChart;

// Get failure risk based on revenue tier
function getFailureRisk(revenue) {
    if (revenue < 500000) return 0.35;  // <$500k: 35% failure risk
    if (revenue < 2000000) return 0.20; // $500k-$2M: 20% failure risk
    return 0.10;                        // >$2M: 10% failure risk
}

// Calculate annual attack probability with EXPONENTIAL security decay
function calculateAnnualAttackProb(year, securityMult, hasOnlinePayment, industry, aiBusinessEnabled, securityBundle) {
    const industryMod = params.industryModifiers[industry]?.mod || 1.0;
    const bundleData = params.securityBundles[securityBundle] || params.securityBundles.traditional;
    const mythosPower = year === 1 ? 0 : year - 1;
    const mythos = Math.pow(params.mythosMultiplier, mythosPower);
    const paymentMod = hasOnlinePayment ? (1 + params.onlinePaymentModifier) : 1;
    
    // AI business increases attack surface (fixed multiplier, not time-dependent)
    const aiAttackSurfaceMult = aiBusinessEnabled ? 1.35 : 1.0;
    
    // Security bundle effectiveness changes over time (EXPONENTIAL decay/growth)
    // Traditional: decays as AI attacks evolve. AI-Powered: improves as it learns
    const yearsPassed = year - 1;
    const effectiveAttackMult = bundleData.baseAttackMult * Math.pow(1 + bundleData.decayRate, yearsPassed);
    
    // Base attack rate with exponential adjustments
    const attackProb = params.baseRate * industryMod * securityMult * effectiveAttackMult *
           params.locationModifiers[year - 1] * paymentMod * mythos * aiAttackSurfaceMult;
    
    return attackProb;
}

// Calculate financial impact for a single breach
function calculateFinancialImpact(rev, hasInsurance, industry, securityBundle) {
    const industryData = params.industryModifiers[industry] || params.industryModifiers.default;
    const bundleData = params.securityBundles[securityBundle] || params.securityBundles.traditional;
    const scaleMod = Math.pow(rev / 500000, 0.6);
    const recoveryCost = params.recoveryCostBase * scaleMod;
    
    // Security bundle affects recovery time
    const baseDowntimeDays = (0.53 * 7) + (0.33 * 90) + (0.14 * 30);
    const adjustedDowntime = baseDowntimeDays * bundleData.recoveryTimeMult * (1 - bundleData.dwellTimeReduction);
    const downtimeCost = industryData.dailyRate * adjustedDowntime;
    
    const regulatoryCost = industryData.regulatoryFine;
    const reputationalCost = 0.12 * rev;  // Base 12% - compounding applied in cumulative calc
    const insuranceReduction = hasInsurance ? recoveryCost * params.insuranceOffset : 0;
    
    return {
        recovery: recoveryCost,
        ransom: recoveryCost * 0.15,
        downtime: downtimeCost,
        regulatory: regulatoryCost,
        reputational: reputationalCost,
        insuranceOffset: -insuranceReduction,
        total: recoveryCost + downtimeCost + regulatoryCost + reputationalCost - insuranceReduction,
        recoveryTimeDays: adjustedDowntime
    };
}

// Calculate survival probability with CASH FLOW CATASTROPHE model
function calculateSurvival(securityMult, hasOnlinePayment, failureRisk, hasInsurance, industry, profitMargin, aiBusinessEnabled, securityBundle, baseRev) {
    const survival = [100];
    let current = 1.0;
    let cashReserves = 0; // Track depleted cash across years
    
    // Base failure risk adjustments
    let adjustedFailureRisk = hasInsurance ? failureRisk * 0.75 : failureRisk;
    const marginMult = params.profitMarginMultipliers[profitMargin] || 1.0;
    adjustedFailureRisk *= marginMult;
    const bundleData = params.securityBundles[securityBundle] || params.securityBundles.traditional;
    adjustedFailureRisk *= (1 - bundleData.survivalImprovement);
    adjustedFailureRisk *= (1 - (bundleData.dwellTimeReduction * 0.5));
    
    // Cash flow parameters based on profit margin
    const cashReserveMonths = params.cashReserveMonths[profitMargin] || 3.5;
    const monthlyProfit = baseRev * (profitMargin === 'low' ? 0.075 : profitMargin === 'medium' ? 0.175 : 0.30) / 12;
    const initialCashReserves = monthlyProfit * cashReserveMonths;
    
    for (let year = 1; year <= 5; year++) {
        const attackProb = calculateAnnualAttackProb(year, securityMult, hasOnlinePayment, industry, aiBusinessEnabled, securityBundle);
        
        // Calculate expected breach cost if attack occurs
        const yearRevenue = getEffectiveRevenueYear(baseRev, aiBusinessEnabled, year);
        const impact = calculateFinancialImpact(yearRevenue, hasInsurance, industry, securityBundle);
        const expectedBreachCost = attackProb * impact.total;
        
        // CASH FLOW CATASTROPHE MODEL
        // If breach occurs and exceeds cash reserves, business faces immediate insolvency
        let cashFlowFailureRisk = 0;
        if (attackProb > 0) {
            const availableCash = initialCashReserves + cashReserves; // Reserves + accumulated cash
            const catastrophicThreshold = monthlyProfit * 12 * params.cashFlowCatastropheThreshold; // 2× annual profit
            
            // If expected breach cost exceeds available cash, high immediate failure risk
            if (expectedBreachCost > availableCash) {
                // Low margin businesses have no buffer - immediate insolvency risk
                const cashShortfall = expectedBreachCost - availableCash;
                cashFlowFailureRisk = Math.min(0.8, cashShortfall / catastrophicThreshold); // Up to 80% immediate failure
            }
            
            // Deduct breach cost from reserves (accumulated losses)
            cashReserves -= expectedBreachCost;
        }
        
        // Add annual profit to cash reserves (rebuilding buffer)
        cashReserves += monthlyProfit * 12;
        
        // Combined survival probability
        const baseSurvival = 1 - (attackProb * adjustedFailureRisk);
        const cashAdjustedSurvival = baseSurvival * (1 - cashFlowFailureRisk);
        current *= cashAdjustedSurvival;
        survival.push(current * 100);
    }
    return survival;
}

// Calculate attack probabilities for all 5 years
function calculateAttackProbs(securityMult, hasOnlinePayment, industry, aiBusinessEnabled, securityBundle) {
    return [1, 2, 3, 4, 5].map(year => 
        calculateAnnualAttackProb(year, securityMult, hasOnlinePayment, industry, aiBusinessEnabled, securityBundle) * 100
    );
}

// Calculate effective revenue with EXPONENTIAL AI market share capture
function getEffectiveRevenueYear(baseRev, aiBusinessEnabled, year) {
    if (!aiBusinessEnabled) return baseRev;
    const growthRate = params.aiBusinessGrowthRate;
    const yearsPassed = year - 1;
    const revenueMult = Math.pow(1 + growthRate, yearsPassed);
    return baseRev * revenueMult;
}

// Calculate AI-driven cost savings (fixed, immediate efficiency)
function getAICostSavings(baseRev, aiBusinessEnabled) {
    if (!aiBusinessEnabled) return 0;
    return baseRev * params.staffCostRatio * params.staffCostReduction;
}

// Calculate cumulative cost with EXPONENTIAL dynamics and compounding reputational damage
function calculateCumulativeCost(securityMult, remediationCost, baseRev, hasOnlinePayment, hasInsurance, industry, aiBusinessEnabled, securityBundle) {
    const failureRisk = getFailureRisk(baseRev);
    const aiSavings = getAICostSavings(baseRev, aiBusinessEnabled);
    
    let cumulative = remediationCost;
    const yearly = [remediationCost];
    let breachHistory = []; // Track years when breaches occurred
    
    for (let year = 1; year <= 5; year++) {
        // Revenue grows exponentially if AI-enabled
        const yearRevenue = getEffectiveRevenueYear(baseRev, aiBusinessEnabled, year);
        
        // Calculate attack probability for this year
        const attackProb = calculateAnnualAttackProb(year, securityMult, hasOnlinePayment, industry, aiBusinessEnabled, securityBundle);
        
        // If breach expected this year, add to history
        if (attackProb > 0) {
            breachHistory.push({ year: year, prob: attackProb });
        }
        
        // Calculate compounding reputational damage from all previous breaches
        let cumulativeReputationalDamage = 0;
        for (const breach of breachHistory) {
            const yearsSinceBreach = year - breach.year;
            // Viral amplification: damage compounds 20% per year
            const reputationMult = Math.pow(1 + params.viralAmplification, yearsSinceBreach);
            const breachDamage = params.baseReputationalHit * yearRevenue * reputationMult * breach.prob;
            cumulativeReputationalDamage += breachDamage;
        }
        
        // Calculate other breach costs
        const impact = calculateFinancialImpact(yearRevenue, hasInsurance, industry, securityBundle);
        const directCosts = attackProb * (impact.recovery + impact.ransom + impact.downtime + impact.regulatory + impact.insuranceOffset);
        
        // Total expected loss = direct costs + compounding reputational damage
        const expectedLoss = directCosts + cumulativeReputationalDamage;
        
        // Subtract AI cost savings each year
        const netYearCost = expectedLoss - aiSavings;
        cumulative += netYearCost;
        yearly.push(cumulative);
    }
    
    // Return final impact with Year 5 reputational damage for display
    const finalYearRevenue = getEffectiveRevenueYear(baseRev, aiBusinessEnabled, 5);
    const finalImpact = calculateFinancialImpact(finalYearRevenue, hasInsurance, industry, securityBundle);
    
    return { yearly, total: cumulative, impact: finalImpact, aiSavings };
}

// ============================================================================
// UI UPDATE FUNCTIONS
// ============================================================================

function updateSimulation() {
    // Get all control values
    const rev = parseInt(document.getElementById('revenueSlider').value);
    const industry = document.getElementById('industrySelect').value;
    const profitMargin = document.getElementById('profitMarginSelect').value;
    const aiBusinessEnabled = document.getElementById('aiBusinessToggle').checked;
    const securityBundle = document.getElementById('securityBundleSelect').value;
    const hasOnlinePayment = document.getElementById('onlineBookingToggle').checked;
    const hasInsurance = document.getElementById('insuranceToggle').checked;
    
    // Calculate failure risk based on effective revenue
    const effectiveRev = getEffectiveRevenueYear(rev, aiBusinessEnabled, 5);
    const failureRisk = getFailureRisk(effectiveRev);
    
    // Update display values
    document.getElementById('revenueValue').textContent = '$' + rev.toLocaleString();
    document.getElementById('aiBusinessValue').textContent = aiBusinessEnabled ? 'Yes (+15% rev, -15% costs, +35% risk)' : 'No — Manual processes';
    document.getElementById('onlineBookingValue').textContent = hasOnlinePayment ? 'Yes (+0.25× risk)' : 'No';
    document.getElementById('insuranceValue').textContent = hasInsurance ? 'Yes (-60% recovery)' : 'No';
    
    // Calculate all scenarios
    const survivalA = calculateSurvival(params.securityMultiplier, hasOnlinePayment, failureRisk, hasInsurance, industry, profitMargin, aiBusinessEnabled, securityBundle, rev);
    const survivalB = calculateSurvival(Math.min(params.securityMultiplier, 0.35), hasOnlinePayment, failureRisk, hasInsurance, industry, profitMargin, aiBusinessEnabled, securityBundle, rev);
    const survivalC = calculateSurvival(params.securityMultiplierC, hasOnlinePayment, failureRisk, hasInsurance, industry, profitMargin, aiBusinessEnabled, securityBundle, rev);
    
    const attackA = calculateAttackProbs(params.securityMultiplier, hasOnlinePayment, industry, aiBusinessEnabled, securityBundle);
    const attackB = calculateAttackProbs(Math.min(params.securityMultiplier, 0.35), hasOnlinePayment, industry, aiBusinessEnabled, securityBundle);
    const attackC = calculateAttackProbs(params.securityMultiplierC, hasOnlinePayment, industry, aiBusinessEnabled, securityBundle);
    
    const costA = calculateCumulativeCost(params.securityMultiplier, 0, rev, hasOnlinePayment, hasInsurance, industry, aiBusinessEnabled, securityBundle);
    const costB = calculateCumulativeCost(Math.min(params.securityMultiplier, 0.35), 15000, rev, hasOnlinePayment, hasInsurance, industry, aiBusinessEnabled, securityBundle);
    const costC = calculateCumulativeCost(params.securityMultiplierC, 18000, rev, hasOnlinePayment, hasInsurance, industry, aiBusinessEnabled, securityBundle);
    
    const impact = costA.impact;
    
    // Update cost panel
    document.getElementById('costA').textContent = '$' + Math.round(costA.total).toLocaleString();
    document.getElementById('costC').textContent = '$' + Math.round(costC.total).toLocaleString();
    document.getElementById('costInaction').textContent = '$' + Math.round(costA.total - costC.total).toLocaleString();
    document.getElementById('roiRatio').textContent = (costA.total / costC.total).toFixed(1) + '×';
    
    // Update charts
    survivalChart.data.datasets[0].data = survivalA;
    survivalChart.data.datasets[1].data = survivalB;
    survivalChart.data.datasets[2].data = survivalC;
    survivalChart.update();
    
    attackChart.data.datasets[0].data = attackA;
    attackChart.data.datasets[1].data = attackB;
    attackChart.data.datasets[2].data = attackC;
    attackChart.update();
    
    financialChart.data.datasets[0].data = [impact.recovery];
    financialChart.data.datasets[1].data = [impact.ransom];
    financialChart.data.datasets[2].data = [impact.downtime];
    financialChart.data.datasets[3].data = [impact.regulatory];
    financialChart.data.datasets[4].data = [impact.reputational];
    financialChart.data.datasets[5].data = [impact.insuranceOffset];
    financialChart.update();
    
    cumulativeChart.data.datasets[0].data = costA.yearly.map((v, i) => i === 0 ? 0 : v);
    cumulativeChart.data.datasets[1].data = costB.yearly;
    cumulativeChart.data.datasets[2].data = costC.yearly;
    cumulativeChart.update();
}

// ============================================================================
// CHART INITIALIZATION
// ============================================================================

function initializeCharts() {
    // CONFIG: Set default initial values (worst-case baseline)
    const initialRev = 250000;  // CONFIG: Set default revenue for sector
    const initialIndustry = 'default';   // CONFIG: Change to your default industry key
    const initialProfitMargin = 'low';  // CONFIG: low/medium/high - affects cash reserves
    const aiBusinessEnabled = false;
    const initialSecurityBundle = 'none';  // CONFIG: none/traditional/ai-powered
    const hasOnlinePayment = true;
    const hasInsurance = false;
    
    const effectiveInitialRev = getEffectiveRevenueYear(initialRev, aiBusinessEnabled, 5);
    const initialFailureRisk = getFailureRisk(effectiveInitialRev);
    
    Chart.defaults.color = '#a0a0a0';
    Chart.defaults.borderColor = '#2d3561';
    
    // Survival Chart
    survivalChart = new Chart(document.getElementById('survivalChart'), {
        type: 'line',
        data: {
            labels: ['Year 0', 'Year 1', 'Year 2', 'Year 3', 'Year 4', 'Year 5'],
            datasets: [{
                label: 'Status Quo (A)',
                data: calculateSurvival(params.securityMultiplier, hasOnlinePayment, initialFailureRisk, hasInsurance, initialIndustry, initialProfitMargin, aiBusinessEnabled, initialSecurityBundle, initialRev),
                borderColor: '#e94560',
                backgroundColor: 'rgba(233, 69, 96, 0.1)',
                fill: true,
                tension: 0.4
            }, {
                label: 'Basic Hardening (B)',
                data: calculateSurvival(Math.min(params.securityMultiplier, 0.35), hasOnlinePayment, initialFailureRisk, hasInsurance, initialIndustry, initialProfitMargin, aiBusinessEnabled, initialSecurityBundle, initialRev),
                borderColor: '#f4a261',
                backgroundColor: 'rgba(244, 162, 97, 0.1)',
                fill: true,
                tension: 0.4
            }, {
                label: 'Full Audit (C)',
                data: calculateSurvival(params.securityMultiplierC, hasOnlinePayment, initialFailureRisk, hasInsurance, initialIndustry, initialProfitMargin, aiBusinessEnabled, initialSecurityBundle, initialRev),
                borderColor: '#2a9d8f',
                backgroundColor: 'rgba(42, 157, 143, 0.1)',
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'bottom' },
                tooltip: {
                    callbacks: {
                        label: (ctx) => `${ctx.dataset.label}: ${ctx.raw.toFixed(1)}%`
                    }
                }
            },
            scales: {
                y: {
                    min: 0,
                    max: 100,
                    title: { display: true, text: 'Survival Probability (%)' }
                }
            }
        }
    });
    
    // Attack Probability Chart
    attackChart = new Chart(document.getElementById('attackChart'), {
        type: 'bar',
        data: {
            labels: ['Year 1', 'Year 2', 'Year 3', 'Year 4', 'Year 5'],
            datasets: [{
                label: 'Status Quo (A)',
                data: calculateAttackProbs(params.securityMultiplier, hasOnlinePayment, initialIndustry, aiBusinessEnabled, initialSecurityBundle),
                backgroundColor: 'rgba(233, 69, 96, 0.7)'
            }, {
                label: 'Basic Hardening (B)',
                data: calculateAttackProbs(Math.min(params.securityMultiplier, 0.35), hasOnlinePayment, initialIndustry, aiBusinessEnabled, initialSecurityBundle),
                backgroundColor: 'rgba(244, 162, 97, 0.7)'
            }, {
                label: 'Full Audit (C)',
                data: calculateAttackProbs(params.securityMultiplierC, hasOnlinePayment, initialIndustry, aiBusinessEnabled, initialSecurityBundle),
                backgroundColor: 'rgba(42, 157, 143, 0.7)'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'bottom' }
            },
            scales: {
                y: {
                    min: 0,
                    max: 100,
                    title: { display: true, text: 'Annual Attack Probability (%)' }
                }
            }
        }
    });
    
    // Financial Breakdown Chart (with multi-color legend)
    const initialImpact = calculateFinancialImpact(effectiveInitialRev, hasInsurance, initialIndustry, initialSecurityBundle);
    financialChart = new Chart(document.getElementById('financialChart'), {
        type: 'bar',
        data: {
            labels: ['Cost Breakdown'],
            datasets: [
                { label: 'Recovery', data: [initialImpact.recovery], backgroundColor: '#4361ee' },
                { label: 'Ransom', data: [initialImpact.ransom], backgroundColor: '#e94560' },
                { label: 'Downtime', data: [initialImpact.downtime], backgroundColor: '#f4a261' },
                { label: 'Regulatory', data: [initialImpact.regulatory], backgroundColor: '#2a9d8f' },
                { label: 'Reputational', data: [initialImpact.reputational], backgroundColor: '#7209b7' },
                { label: 'Insurance', data: [initialImpact.insuranceOffset], backgroundColor: '#2a9d8f' }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { 
                legend: { 
                    display: true,
                    position: 'bottom',
                    labels: { boxWidth: 12, font: { size: 10 }, usePointStyle: true }
                },
                tooltip: {
                    callbacks: {
                        label: (ctx) => ctx.dataset.label + ': $' + Math.round(ctx.raw).toLocaleString()
                    }
                }
            },
            scales: { 
                x: { display: false },
                y: { 
                    title: { display: true, text: 'AUD ($)' },
                    ticks: { callback: (val) => '$' + (val / 1000) + 'k' }
                }
            }
        }
    });
    
    // Cumulative Cost Chart
    const costA = calculateCumulativeCost(params.securityMultiplier, 0, initialRev, hasOnlinePayment, hasInsurance, initialIndustry, aiBusinessEnabled, initialSecurityBundle);
    const costB = calculateCumulativeCost(Math.min(params.securityMultiplier, 0.35), 15000, initialRev, hasOnlinePayment, hasInsurance, initialIndustry, aiBusinessEnabled, initialSecurityBundle);
    const costC = calculateCumulativeCost(params.securityMultiplierC, 18000, initialRev, hasOnlinePayment, hasInsurance, initialIndustry, aiBusinessEnabled, initialSecurityBundle);
    
    cumulativeChart = new Chart(document.getElementById('cumulativeChart'), {
        type: 'line',
        data: {
            labels: ['Year 0', 'Year 1', 'Year 2', 'Year 3', 'Year 4', 'Year 5'],
            datasets: [{
                label: 'Status Quo (A)',
                data: costA.yearly.map((v, i) => i === 0 ? 0 : v),
                borderColor: '#e94560',
                backgroundColor: 'rgba(233, 69, 96, 0.1)',
                fill: true,
                tension: 0.4
            }, {
                label: 'Basic Hardening (B)',
                data: costB.yearly,
                borderColor: '#f4a261',
                backgroundColor: 'rgba(244, 162, 97, 0.1)',
                fill: true,
                tension: 0.4
            }, {
                label: 'Full Audit (C)',
                data: costC.yearly,
                borderColor: '#2a9d8f',
                backgroundColor: 'rgba(42, 157, 143, 0.1)',
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'bottom' },
                tooltip: {
                    callbacks: {
                        label: (ctx) => `${ctx.dataset.label}: $${Math.round(ctx.raw).toLocaleString()}`
                    }
                }
            },
            scales: {
                y: {
                    title: { display: true, text: 'Cumulative Expected Cost (AUD)' },
                    ticks: { callback: (val) => '$' + (val / 1000) + 'k' }
                }
            }
        }
    });
    
    // Initialize cost panel
    document.getElementById('costA').textContent = '$' + Math.round(costA.total).toLocaleString();
    document.getElementById('costC').textContent = '$' + Math.round(costC.total).toLocaleString();
    document.getElementById('costInaction').textContent = '$' + Math.round(costA.total - costC.total).toLocaleString();
    document.getElementById('roiRatio').textContent = (costA.total / costC.total).toFixed(1) + '×';
}

// ============================================================================
// EVENT LISTENERS - Set up when DOM is ready
// ============================================================================

document.addEventListener('DOMContentLoaded', function() {
    // Initialize all charts
    initializeCharts();
    
    // Add event listeners for all controls
    document.getElementById('revenueSlider').addEventListener('input', updateSimulation);
    document.getElementById('industrySelect').addEventListener('change', updateSimulation);
    document.getElementById('profitMarginSelect').addEventListener('change', updateSimulation);
    document.getElementById('aiBusinessToggle').addEventListener('change', updateSimulation);
    document.getElementById('securityBundleSelect').addEventListener('change', updateSimulation);
    document.getElementById('onlineBookingToggle').addEventListener('change', updateSimulation);
    document.getElementById('insuranceToggle').addEventListener('change', updateSimulation);
});
