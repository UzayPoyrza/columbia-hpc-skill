# Terremoto - Software

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62140811/Terremoto+-+Software

---

The current Unix (Linux) version on a cluster node can be retrieved with the following command:

$ cat /etc/redhat-release

The command 'uname -a' returns the version and release of the Unix kernel.

For equivalent info along with specification of the version of the default installed gcc (GNU Compiler Collection), type:

$ cat /proc/version

The table below shows software already installed on the cluster system-wide.

The list may be partial and not totally up-to-date at any given time. Use one of the following commands to verify whether unlisted software/packages can be found on Terremoto otherwise:

**$ module avail**

$ rpm -qa <packageName>

$ locate <name>

| Name | Version | Location / Module | RPM / files | Category |
| --- | --- | --- | --- | --- |
| anaconda2 | python 2.7.16 | module load anaconda/2-2019.03 | /moto/opt/anaconda2-2019.03/bin/python | Python for Scientific Computing |
| anaconda3 | python 3.9.12 | module load anaconda/3-2022.05 | /moto/opt/anaconda3-2022.05/bin/python3 | Python for Scientific Computing |
| cuda | 11.0 | module load cuda11.0/toolkit | /cm/shared/apps/cuda11.0/toolkit | GPU Computing |
| gcc | 11.2.0 | module load gcc/11.2.0 | /bin/gcc | Compiler - C / C++ |
| intel-parallel-studio | 2020 | module load intel-parallel-studio/2020 | /moto/opt/parallel\_studio\_xe\_2020 | Intel Compiler |
| knitro | 13.2.0 | module load knitro/13.2.0 | /moto/opt/knitro-13.2.0-Linux-64 | Solving large scale nonlinear mathematical optimization problems |
| matlab | R2022b | module load matlab/2022b | /moto/matlab/R2022b | Numerical Computing |
| openmpi | 4.0.0 | module load openmpi/gcc/64/4.0.0 | /moto/opt/openmpi-4.0.0/bin/ | OpenMPI Compiler |
| R | 4.2.2 | module load R/4.2.2 | /moto/opt/R-4.2.2 | Programming Language |
| Singularity | 3.5.3 | module load singularity | /moto/opt/singularity-3.5.3 | Run Docker-like containers |
| Stata | 16 | module load stata/16 | /moto/opt/stata16 | General-purpose statistical software |
