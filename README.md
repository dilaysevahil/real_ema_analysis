# Real EMA Data Mini-Analysis (NSMD PhD Prototype)

**Dataset**: Bringmann et al. (2013) Ecological Momentary Assessment data from a mindfulness intervention trial for individuals vulnerable to depression.

### What I Did
- Loaded and cleaned real EMA data (~28,600 observations, 6 symptoms)
- Handled high missingness (~59%) with listwise deletion
- Split data into **Pre-intervention** vs **During-intervention** phases
- Estimated contemporaneous symptom networks for:
  - One-time (full period) network
  - Phase-specific updated networks
- Compared **strength centrality** across phases

### Key Insight
Symptom networks changed across the intervention phase (e.g., Sadness and Anxious became more central, Pleasant events relatively less central). This demonstrates the value of periodically updating networks during treatment.

### Relevance 
This analysis directly engages with:
- Constructing and analyzing dynamic symptom networks from EMA data
- Evaluating one-time vs. updated networks during therapy
- Bridging data-driven networks with clinical decision-making (links to my ABA experience and PECAN co-creation)

**Note**: In a full project I would extend this with mlVAR temporal networks and multiple imputation.
