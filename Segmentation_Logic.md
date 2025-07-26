### Customer Segmentation (RFM Analysis Logic)

This section details the methodology used to segment customers based on their Recency, Frequency, and Monetary (RFM) values.

**Purpose:**
Customer segmentation enables targeted marketing, personalized engagement strategies, and a deeper understanding of diverse customer behaviors within the dataset.

**Methodology: Recency, Frequency, Monetary (RFM) Analysis**
RFM analysis is a powerful technique that quantifies customer value based on three key dimensions of their purchasing behavior:

* **Recency (R):** How recently a customer made a purchase. (Measured in days from the analysis's snapshot date).
* **Frequency (F):** How often a customer makes purchases. (Measured by the total number of unique orders).
* **Monetary (M):** How much money a customer spends. (Measured by their total spending).

**RFM Scoring & Tiers (1-4 Scale, 4 is Best):**
To standardize and categorize customers based on their raw RFM values, each customer's Recency, Frequency, and Monetary score was assigned a tier from 1 to 4. In this scoring system, a score of **4 consistently represents the "best" characteristic** (most recent, most frequent, highest spend), while 1 represents the "worst."

The tier assignment was performed using Oracle's `NTILE()` window function, which divides the dataset into `N` equal groups. To ensure a consistent "4 is best" scoring across all metrics, the `NTILE()` function's ordering and subsequent inversion (`5 - NTILE(...)`) were carefully applied:

* **Recency Score (R_Score):**
    * **Logic:** Lower `RecencyDays` values indicate a more recent (better) customer.
    * **Calculation:** `5 - NTILE(4) OVER (ORDER BY RecencyDays ASC)`
    * *Explanation:* `NTILE(4) OVER (ORDER BY RecencyDays ASC)` assigns 1 to the most recent customers (lowest `RecencyDays`) and 4 to the least recent. Subtracting this result from 5 effectively inverts the score, so the most recent customers get an R_Score of 4, and the least recent get 1.

* **Frequency Score (F_Score):**
    * **Logic:** Higher `Frequency` values indicate a more frequent (better) customer.
    * **Calculation:** `5 - NTILE(4) OVER (ORDER BY Frequency DESC)`
    * *Explanation:* `NTILE(4) OVER (ORDER BY Frequency DESC)` assigns 1 to the most frequent customers (highest `Frequency`) and 4 to the least frequent. Subtracting this result from 5 inverts the score, so the most frequent customers get an F_Score of 4, and the least frequent get 1.

* **Monetary Score (M_Score):**
    * **Logic:** Higher `Monetary` values indicate a higher-spending (better) customer.
    * **Calculation:** `5 - NTILE(4) OVER (ORDER BY Monetary DESC)`
    * *Explanation:* `NTILE(4) OVER (ORDER BY Monetary DESC)` assigns 1 to the highest-spending customers (highest `Monetary`) and 4 to the lowest-spending. Subtracting this result from 5 inverts the score, so the highest-spending customers get an M_Score of 4, and the lowest-spending get 1.

**Customer Segment Definitions:**
Based on the combined R, F, and M scores (where 4 is always best), customers were categorized into the following distinct segments using SQL `CASE` statements. The average RFM values for each segment (as observed from analysis) align with these definitions:

* **01_Champions (R4, F4, M4):**
    * *Characteristics:* Most recent, most frequent, and highest-spending customers. These are your best and most loyal customers.
    * *Observed Averages:* Very low `AvgRecency`, very high `AvgFrequency`, very high `AvgMonetary`.

* **02_Loyal Customers (R>=3, F>=3, M>=3):**
    * *Characteristics:* Very good overall, consistently buying and spending well, just below the top tier of Champions.
    * *Observed Averages:* Low `AvgRecency`, high `AvgFrequency`, high `AvgMonetary`.

* **03_Promising (R4, F2-3, M2-3 OR R2-3, F4, M4):**
    * *Characteristics:* Very recent, but potentially still growing in frequency or monetary value OR moderate recency but very high frequency and monetary. They show strong potential for growth into Loyal or Champions.
    * *Observed Averages:* Low to moderate `AvgRecency`, good `AvgFrequency`, good `AvgMonetary`.

* **04_New Customers (R4, F1, M1):**
    * *Characteristics:* Very recent first-time buyers with low frequency and monetary value.
    * *Observed Averages:* Very low `AvgRecency`, very low `AvgFrequency`, very low `AvgMonetary`.

* **05_Big Spenders (R>=3, F<=2, M4):**
    * *Characteristics:* Recent or moderately recent customers who make large purchases but not very frequently. High monetary value is their defining trait.
    * *Observed Averages:* Low to moderate `AvgRecency`, low `AvgFrequency`, very high `AvgMonetary`.

* **06_At Risk (R<=2, F>=3, M>=3):**
    * *Characteristics:* Customers who used to be frequent and high-spending but haven't purchased recently. They are at risk of churning.
    * *Observed Averages:* High `AvgRecency`, good `AvgFrequency`, good `AvgMonetary`.

* **07_Needs Attention (R2-3, F2-3, M2-3):**
    * *Characteristics:* Customers with mid-range scores across all dimensions. They are consistent but not top-tier and could be encouraged to move up.
    * *Observed Averages:* Moderate `AvgRecency`, moderate `AvgFrequency`, moderate `AvgMonetary`.

* **08_Lost Customers (R1, F<=2, M<=2):**
    * *Characteristics:* Customers who haven't purchased for a long time and have low frequency and monetary value. They are likely churned.
    * *Observed Averages:* Very high `AvgRecency`, very low `AvgFrequency`, very low `AvgMonetary`.

* **09_Other Segments:**
    * *Characteristics:* A catch-all for any less common or unique score combinations not explicitly defined in the above segments.
    * *Observed Averages:* Varied, typically lower to mid-range values.