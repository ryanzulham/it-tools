# Health Thresholds & Decision Rule

Interpret each collected reading using the bands below. Assign GREEN / YELLOW / RED and a
one-line reason grounded in the actual number. When a metric is missing or a component is
absent, mark it N/A — never fabricate a value.

## Battery

**Health %** = `MaxCapacity / DesignCapacity × 100` (macOS uses mAh; Windows uses mWh).

| Metric | GREEN | YELLOW | RED |
|---|---|---|---|
| Health % | ≥ 85% | 70–84% | < 70% |
| Cycle count | < 60% of rated | 60–100% of rated | > rated max |
| Vendor condition | "Normal" | — | "Service Recommended" / "Replace Soon/Now" |
| Physical | flat | — | swollen/bulging (SAFETY — RED regardless of %) |

Typical rated cycle maximums: modern MacBooks ~1000; most Windows/Linux laptops 300–500 (older) or ~1000 (newer). A swollen battery is always RED and urgent.

## RAM & Swap

| Metric | GREEN | YELLOW | RED |
|---|---|---|---|
| Total RAM (office/business use) | ≥ 16 GB | 8 GB | ≤ 4 GB |
| Swap in active use | minimal | some swap, machine responsive | swap ≈ RAM size, constant swapping |
| Lifetime swapins/swapouts | low | moderate | millions + user reports lag |
| Upgradeable? | yes (slots) | — | no (soldered) → repair not an option |

Soldered RAM that is too small is a strong REPLACE signal because it cannot be economically fixed.

## CPU

**Load ratio** = `load average ÷ number of cores`. > 1.0 sustained = oversubscribed.

| Metric | GREEN | YELLOW | RED |
|---|---|---|---|
| Load ratio (sustained) | < 0.7 | 0.7–1.5 | > 1.5 |
| Core count vs. workload | adequate | tight (2 cores, heavy apps) | insufficient |
| Generation / age | < 4 yrs | 4–7 yrs | > 7 yrs |

## Storage (SSD/HDD)

| Metric | GREEN | YELLOW | RED |
|---|---|---|---|
| SMART status | Verified / OK / Healthy | — | Failing / not Verified |
| SSD wear (Percentage Used / Wear%) | < 50% | 50–80% | > 80% |
| Free space | > 20% | 10–20% | < 10% |
| Reallocated / pending sectors (HDD) | 0 | few | growing |

A failing SMART status is RED and urgent (data-loss risk).

## Thermal

| State | GREEN | YELLOW | RED |
|---|---|---|---|
| Throttling | none (speed limit 100%) | occasional | sustained throttling / thermal shutdowns |
| Temps under load | within spec | near limit | exceeding limit repeatedly |

## OS / Security Support

| State | GREEN | YELLOW | RED |
|---|---|---|---|
| Support status | current, updates flowing | last supported version, EOL approaching | past end-of-support, no upgrade path |

An OS past end-of-support on hardware that cannot upgrade is a RED business-risk signal even if the hardware still runs.

---

## Repair-vs-Replace Decision Rule

Evaluate in this order; the first matching rule wins.

1. **REPLACE — URGENT (now):** any RED *safety/data* item present →
   - swollen or failing battery ("Service Recommended" + health <70% + high cycles), OR
   - SSD/HDD SMART failing, OR
   - OS past end-of-support with no upgrade path on the current hardware.

2. **REPLACE — PLAN (within 1 quarter):** 2 or more RED/YELLOW items that cannot be
   economically repaired (classic case: soldered RAM too small + worn battery + CPU/OS
   aging). Repairing one component does not resolve the others, so replacement is the
   rational spend.

3. **REPAIR:** exactly one isolated, economical fault on an otherwise capable and
   upgradeable machine (e.g. only the battery is worn; RAM/SSD are user-upgradeable and
   adequate). Repair cost should be well below replacement value.

4. **KEEP:** all components GREEN/YELLOW with no safety issue and no economic case to act.

### Cost sanity check

Before recommending repair, compare the repair estimate to the machine's replacement value.
If repair cost approaches a large fraction of a new unit — or fixes only one of several
limiting factors — recommend REPLACE instead. State the estimated figures in the report.

### Suggested minimum replacement specs (office/business use)

- RAM: **16 GB minimum**
- Storage: **512 GB SSD minimum**
- CPU: modern (Apple M-series / Intel Core Ultra / AMD Ryzen equivalent, < 2 yrs old)
- Warranty: business/pro tier where available
