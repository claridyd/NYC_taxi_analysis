--- This file contains the *final* query and modifications done to pull the data for this project.
--- The query was run directly in the Google BigQuery console to create a table within the UCF-automate-NYC project 
--- Several iterations of queries were during the data exploration process. Initial exploration began with each of the 2009 through 2019 data sets.
--- For expedition of the project, only July 2015 was used for the project.

-- >> FINAL CLEAN RUN >>
SELECT
  pickup_datetime,
  dropoff_datetime,
  pickup_longitude,
  pickup_latitude,
  dropoff_longitude,
  dropoff_latitude,
  rate_code,
  trip_distance,
  fare_amount,
  extra,
  tip_amount,
  total_amount
FROM
  `bigquery-public-data.new_york.tlc_yellow_trips_2015`
WHERE
      (payment_type = '1' OR payment_type LIKE 'CR%' OR payment_type LIKE 'Cr%' OR payment_type LIKE 'cr%')
  AND (rate_code = 1 OR rate_code = 2 OR rate_code = 3)
  AND (pickup_datetime >= '2015-07-01' AND pickup_datetime < '2015-08-01')
  AND (dropoff_datetime >= '2015-07-01' AND dropoff_datetime < '2016-08-02')
  AND (pickup_datetime != dropoff_datetime)
  AND (pickup_longitude != dropoff_longitude OR pickup_latitude != dropoff_latitude)
  AND (pickup_longitude <= -73.699215 AND pickup_longitude >= -74.257159)
  AND (dropoff_longitude <= -71.391523 AND dropoff_longitude >= -76.564851)
  AND (pickup_latitude >= 40.495992 AND pickup_latitude <= 40.915568)
  AND (dropoff_latitude >= 38.756862 AND dropoff_latitude <= 42.654698)
  AND (trip_distance >=0.5 AND trip_distance <= 200)
  AND (fare_amount >= 1 AND fare_amount <=250)
  AND (extra >= 0 AND extra <= fare_amount*10)
  AND tip_amount >= 0
  AND total_amount < (fare_amount*20)
  AND total_amount <=250
ORDER BY
  pickup_datetime;

-- >> ADDED COLUMN ride_minutes in BigQuery console via schema edit >>

-- >> UPDATE ride_minutes >>
UPDATE `cleaned.JULY_2015`
SET ride_minutes = TIMESTAMP_DIFF(dropoff_datetime , pickup_datetime , MINUTE )
WHERE dropoff_datetime IS NOT NULL

-- >> DROP RIDE_MINUTES OUTLIERS : HIGH >> [77,391 REMOVED]
DELETE FROM `ucf-automate-nyc.cleaned.JULY_2015` WHERE ride_minutes > 180

-- >> DROP RIDE_MINUTES OUTLIERS : LOW >> [26,860 REMOVED]
DELETE FROM `ucf-automate-nyc.cleaned.JULY_2015` WHERE ride_minutes < 2

-- >> COULD HAVE COMBINED THE FINAL TWO DELETE MODIFICATIONS, BUT WANTED TO SEE THE COUNT OF REMOVED ITEMS PER DELETION >>