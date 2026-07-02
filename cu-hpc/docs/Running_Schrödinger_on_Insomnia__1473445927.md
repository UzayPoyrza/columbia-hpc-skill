# Running Schrödinger on Insomnia

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/1473445927/Running+Schr+dinger+on+Insomnia

---

This guide outlines the recommended workflow for running Schrödinger suites (Maestro, Jaguar, Desmond, etc.) on the Insomnia cluster.

**Remote Job Submission via GUI is not supported.** Insomnia does not utilize a "Job Server." All jobs must be submitted via the command line using the submit script or interactive job.

---

## **The Recommended Workflow**

To ensure your jobs run reliably and respect cluster resources, follow the Prepare-Transfer-Submit model.

### **1. Prepare (Local Desktop)**

1. Open **Maestro** on your local workstation.
2. Set up your molecular system and calculation parameters as usual.
3. Instead of clicking **Run**, go to the job settings and select **"Write"** or **"Generate Input Files."**
4. This will create several files (e.g., `.mae`, `.in`, or `.jag`) on your local machine.

### **2. Transfer (To Insomnia)**

Upload your generated input files to your Insomnia home or scratch directory using `scp` or Globus.

```
scp my_calculation.mae your_uni@insomnia.rcs.columbia.edu:/specified_location
```

### **3. Execute the Job:**

There are two options on how to submit the input file.

#### Option A (Interactive):

- Start an interactive session (`srun -A <account> -p <partition> --pty /bin/bash`), then:

```
module load schrodinger/2025-2
$SCHRODINGER/<application> run <input_file> -WAIT
```

#### Option B (Batch):

- Submit via an sbatch script (recommended for longer calculations).
- Create a Slurm submission script (e.g., `submit_job.sh`).

#### **Sample** `sbatch` **Template**

```
#!/bin/bash
#SBATCH --job-name=schrodinger_job
#SBATCH -A <account>
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH -p <partition>

# Load the module
module load schrodinger/2025-2  # Use the version installed on the cluster

# Set the absolute path for Schrödinger
export SCHRODINGER=/insomnia001/shared/apps/schrodinger/2025-2

# Run the calculation 
# Replace 'jaguar' and 'input.in' with your specific application and file
$SCHRODINGER/run jaguar run input.in
```

Submit the script:

```
sbatch submit_job.sh
```

### 4. Analyze Results

Once the job is complete, transfer the resulting .mae (or .mae.gz) file back to your local machine and import it into Maestro for visualization.

### Resources

If you are new to the command-line interface, [Schrödinger’s documentation](https://learn.schrodinger.com/private/edu/release/current/Documentation/html/Home.htm) provides extensive examples and test files. If you have any technical questions regarding Schrödinger, you can open a ticket with them by emailing them at [help@schrodinger.com](mailto:help@schrodinger.com).

Any questions regarding the HPC cluster, you can email us at [hpc-support@columbia.edu.](mailto:hpc-support@columbia.edu)
