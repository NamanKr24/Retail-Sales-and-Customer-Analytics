-- Drop the table if it already exists (for re-running if needed)
DROP TABLE Customer_Segments;

-- Create Customer_Segments table with RFM scores and Segment
CREATE TABLE Customer_Segments AS
WITH RFM_Scores AS (
    SELECT
        CustomerID,
        RecencyDays,
        Frequency,
        Monetary,
        -- R_Score: Lower RecencyDays (more recent) gets higher score (4 is best)
        5 - NTILE(4) OVER (ORDER BY RecencyDays ASC) AS R_Score,
        -- F_Score: Higher Frequency gets higher score (4 is best)
        5 - NTILE(4) OVER (ORDER BY Frequency DESC) AS F_Score, -- Corrected: DESC order then 5 - NTILE
        -- M_Score: Higher Monetary gets higher score (4 is best)
        5 - NTILE(4) OVER (ORDER BY Monetary DESC) AS M_Score  -- Corrected: DESC order then 5 - NTILE
    FROM
        Customer_Metrics -- Using the table we just created
)
SELECT
    rs.CustomerID,
    rs.RecencyDays,
    rs.Frequency,
    rs.Monetary,
    rs.R_Score,
    rs.F_Score,
    rs.M_Score,
    -- Assign customer segment based on RFM scores (using the 4=best scheme)
    CASE
        -- Champions: R=4, F=4, M=4 (most recent, most frequent, highest spend)
        WHEN R_Score = 4 AND F_Score = 4 AND M_Score = 4 THEN '01_Champions'

        -- Loyal Customers: R3-4, F3-4, M3-4 (very good across the board, just below champions)
        WHEN R_Score >= 3 AND F_Score >= 3 AND M_Score >= 3 THEN '02_Loyal Customers'

        -- Promising: R4, F2-3, M2-3 (recent, good potential for frequency/monetary growth)
        WHEN R_Score = 4 AND F_Score BETWEEN 2 AND 3 AND M_Score BETWEEN 2 AND 3 THEN '03_Promising'
        WHEN R_Score BETWEEN 2 AND 3 AND F_Score = 4 AND M_Score = 4 THEN '03_Promising' -- High F,M but moderate R

        -- New Customers: R4, F1, M1 (very recent, but lowest frequency and monetary)
        WHEN R_Score = 4 AND F_Score = 1 AND M_Score = 1 THEN '04_New Customers'

        -- Big Spenders: R3-4, F1-2, M4 (recent/good recency, but highest monetary despite lower frequency)
        WHEN R_Score >= 3 AND F_Score <= 2 AND M_Score = 4 THEN '05_Big Spenders'

        -- At Risk: R1-2, F3-4, M3-4 (used to be good, but recency has dropped significantly)
        WHEN R_Score <= 2 AND F_Score >= 3 AND M_Score >= 3 THEN '06_At Risk'

        -- Needs Attention: R2-3, F2-3, M2-3 (middle-of-the-road, consistent but not top tier)
        WHEN R_Score BETWEEN 2 AND 3 AND F_Score BETWEEN 2 AND 3 AND M_Score BETWEEN 2 AND 3 THEN '07_Needs Attention'

        -- Lost Customers: R1, F1-2, M1-2 (lowest scores for Recency, Frequency, and Monetary)
        WHEN R_Score = 1 AND F_Score <= 2 AND M_Score <= 2 THEN '08_Lost Customers'

        ELSE '09_Other Segments' -- Catch-all for any remaining less common combinations
    END AS RFM_Segment
FROM
    RFM_Scores rs
ORDER BY
    rs.CustomerID;

SELECT
    RFM_Segment,
    COUNT(CustomerID) AS NumberOfCustomers,
    ROUND(AVG(RecencyDays), 2) AS AvgRecency,
    ROUND(AVG(Frequency), 2) AS AvgFrequency,
    ROUND(AVG(Monetary), 2) AS AvgMonetary
FROM
    Customer_Segments
GROUP BY
    RFM_Segment
ORDER BY
    RFM_Segment;