# Running MRtrix in a Singularity container

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/167674337/Running+MRtrix+in+a+Singularity+container

---

MRtrix3 provides a large suite of tools for image processing, analysis and visualization, with a focus on the analysis of white matter using diffusion-weighted MRI. It requires several dependencies that make it easier to run as a container. However, [as noted in the documentation](https://mrtrix.readthedocs.io/en/3.0.4/installation/build_from_source.html#install-dependencies), to run the GUI components of MRtrix3 (`mrview` & `shview`), an OpenGL 3.3 compliant graphics card is required as well as the corresponding software driver. This implies you cannot run the GUI components over a remote X11 connection, since it can’t support OpenGL 3.3+ rendering. Most of the other commands will run with the container. You can [follow the tutorial](https://mrtrix.readthedocs.io/en/3.0.4/installation/using_containers.html#using-singularity) and the following set of commands work on Ginsburg. `mredit` and `voxel2mesh` are two examples:

```
ml singularity
singularity build MRtrix3.sif docker://mrtrix3/mrtrix3:latest
export SINGULARITYENV_DISPLAY=$DISPLAY
export SINGULARITYENV_XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR
singularity run --cleanenv -B /run MRtrix3.sif /opt/mrtrix3/bin/voxel2mesh
MRtrix 3.0.4                       voxel2mesh                        Dec 14 2022

     voxel2mesh: part of the MRtrix3 package
     
singularity run --cleanenv -B /run ../MRtrix3.sif /opt/mrtrix3/bin/mredit
MRtrix 3.0.4                         mredit                          Dec 14 2022

     mredit: part of the MRtrix3 package
```
