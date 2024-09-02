#!/bin/bash
# retrieve all the InstanceId that were launched before 2022-04-12T13:00:00 from the csv file

# Define the target date and time
TARGET_DATE="2022-04-12 13:00:00"

# Path to the CSV file
CSV_FILE="/home/ubuntu/ec2-instances.csv"

# Convert target date to timestamp
# Convert to a unix timestamp 
target_timestamp=$(date -d "$TARGET_DATE" +%s)

# Read the CSV file and process each line
while IFS=, read -r instance_id launch_datetime type ip spot; do
    # Skip the header line and handle any lines that don't have enough columns
    if [[ "$instance_id" == "InstanceId" ]] || [[ -z "$instance_id" ]]; then
        continue
    fi
    
    # Remove surrounding quotes from fields
    instance_id=$(echo "$instance_id" | tr -d '"')
    launch_datetime=$(echo "$launch_datetime" | tr -d '"')

    # Reformat launch datetime to the correct format
    reformatted_datetime=$(echo "$launch_datetime" | awk '{print $2 " " $1}')

    # Convert reformatted launch datetime to timestamp
    launch_timestamp=$(date -d "$reformatted_datetime" +%s 2>/dev/null)
    
    # Check if the date conversion was successful
    if [[ $? -ne 0 ]]; then
        echo "Skipping invalid date: $launch_datetime"
        continue
    fi
    
    # Compare launch time with target date
    if [[ $launch_timestamp -lt $target_timestamp ]]; then
        echo "Instance ID: $instance_id, Launch Time: $launch_datetime"
    fi
done < "$CSV_FILE"
