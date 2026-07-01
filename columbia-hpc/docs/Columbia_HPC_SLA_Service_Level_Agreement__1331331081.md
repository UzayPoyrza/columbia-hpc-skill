# Columbia HPC SLA (Service Level Agreement)

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/1331331081/Columbia+HPC+SLA+Service+Level+Agreement

---

**Service Level Agreement between CUIT and SRCPAC Operating Committee for Shared Research Computing Facility and HPC Service**

Updated December 5, 2025

- [Introduction](#ColumbiaHPCSLA(ServiceLevelAgreement)-Introduction)
- [Terms of Agreement](#ColumbiaHPCSLA(ServiceLevelAgreement)-TermsofAgreement)
- [SLA Overview](#ColumbiaHPCSLA(ServiceLevelAgreement)-SLAOverview)
- [Operations Policies](#ColumbiaHPCSLA(ServiceLevelAgreement)-OperationsPolicies)
- [Use of Restricted/Sensitive Data](#ColumbiaHPCSLA(ServiceLevelAgreement)-UseofRestricted/SensitiveData)
- [User Accounts](#ColumbiaHPCSLA(ServiceLevelAgreement)-UserAccounts)
  - [User Access Provisioning Procedures](#ColumbiaHPCSLA(ServiceLevelAgreement)-UserAccessProvisioningProcedures)
  - [User Access De-provisioning Procedures](#ColumbiaHPCSLA(ServiceLevelAgreement)-UserAccessDe-provisioningProcedures)
- [Software](#ColumbiaHPCSLA(ServiceLevelAgreement)-Software)
- [Preventing and Responding to HPC Cluster Problems](#ColumbiaHPCSLA(ServiceLevelAgreement)-PreventingandRespondingtoHPCClusterProblems)
  - [Scheduled Downtimes](#ColumbiaHPCSLA(ServiceLevelAgreement)-ScheduledDowntimes)
  - [Unscheduled Downtime and Critical Problems](#ColumbiaHPCSLA(ServiceLevelAgreement)-UnscheduledDowntimeandCriticalProblems)
  - [Other Problems](#ColumbiaHPCSLA(ServiceLevelAgreement)-OtherProblems)
- [User Support](#ColumbiaHPCSLA(ServiceLevelAgreement)-UserSupport)
- [Problem Escalation](#ColumbiaHPCSLA(ServiceLevelAgreement)-ProblemEscalation)

---

# **Introduction**

This Service Level Agreement (SLA) provides the details of operation as well as the details of preventing and responding to problems for CUIT’s High Performance Computing (HPC) service using the shared HPC cluster. These details are to be agreed upon by CUIT and the Chair of the Shared Research Computing Policy Advisory Committee (SRCPAC).

Beyond the agreement below, users of this system must adhere to all University policies, including all Information Technology Policies, listed at <http://www.essential-policies.columbia.edu> .

# **Terms of Agreement**

This agreement began in 2013, updated 2025 and remains in effect for the life of the HPC Service unless terminated in writing by either the SRCPAC or CUIT.  Changes that need to be made to this agreement must be approved by both parties and documented in the SLA. Changes must be agreed to by both parties before taking effect.

# **SLA Overview**

Columbia University Information Technology (CUIT) and the Shared Research Computing Policy Advisory Committee (SRCPAC) have entered into an agreement for CUIT to provide an HPC service.

The following are the basic components of the shared HPC cluster covered by this SLA:

- Management nodes: these are the nodes that manage the clusters and provide access, security, job submission, transfer.
- Execute nodes: compute servers where users run their jobs.
- Scratch Storage: non-backed up storage space for working files, submit scripts, and input/output for jobs.s.

**There are four levels of support for the HPC participants:**

Purchasers, Renters, Educational, and Free tiers all contact [hpc-support@columbia.edu](mailto:hpc-support@columbia.edu)

Free users receive the lowest priority, and support is limited to online documentation only.

# **Operations Policies**

The SRCPAC sets policies for the operation of the cluster in conjunction with RCS staff advice and guidance on system capabilities.  Any unresolved disputes escalate to the SRCPAC, then to the Research Computing Executive Committee (RCEC), respectively.

# **Use of Restricted/Sensitive Data**

Data use should adhere to all applicable data agreements and Columbia University policies. The HPC system has not been certified for any use of PII, PHI, or HIPAA data.

# **User Accounts**

A valid UNI and UNI password is required to access the system.

A designated contact in each research group with a purchased share of shared HPC systems will decide which individuals are allowed to have a user account for a research group. Renters and free users are provided with individual user accounts.

## *User Access Provisioning Procedures*

Designated research group contacts of purchasers should email [hpc-support@columbia.edu](mailto:hpc-support@columbia.edu) to request that a UNI be added to a group. CUIT will establish access for each renter and free user within **two (2) business days** after they successfully apply to use the system.

## *User Access De-provisioning Procedures*

Designated research group contacts should email [hpc-support@columbia.edu](mailto:hpc-support@columbia.edu) to request that a UNI be removed from a group. CUIT will remove access for each renter and free user when their period of system use has ended.

# **Software**

A suite of software applications and libraries is installed on the cluster and available to all users. See [online documentation](https://columbiauniversity.atlassian.net/wiki/spaces/rcs) to access the current list of this software.

A department or group may purchase licenses for specialized software. Arrangements can be made for CUIT to install and configure this software by contacting [hpc-support@columbia.edu](mailto:hpc-support@columbia.edu). CUIT installation of the software will comply with licensing agreements.

# **Preventing and Responding to HPC Cluster Problems**

## ***Scheduled Downtimes***

CUIT will implement [quarterly maintenance windows](https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/1282539535/Quarterly+Maintenance+Schedule+for+Columbia+HPC+Clusters), occurring every three (3) months, to permit systems engineers to perform necessary system updates, patches, and upgrades. Each maintenance window will span a three (3)-day duration and will take place during the second week of March, June, September, and December each year.

CUIT will issue service alerts 30 days in advance of each scheduled maintenance window as a formal reminder to all researchers. While these quarterly windows are reserved on the annual calendar, they may remain unused if no updates, patches, or enhancements are required for that cycle. In such instances, no maintenance activities will be initiated, and all clusters will remain fully operational.

In the event that emergency corrective actions are required, such as hardware failures, disk replacements, storage incidents, or other time-sensitive repairs, CUIT may establish a shorter maintenance window outside of the quarterly schedule. When such an emergency window is necessary, CUIT will provide no less than ten (10) days’ notice, whenever practicable.

CUIT will publish the annual maintenance schedule and will notify system users of any scheduled downtime that will be executed under this policy.

## ***Unscheduled Downtime and Critical Problems***

CUIT technical staff have monitoring tools in place to check availability of the HPC services. These tools operate 24x7 and will notify the CUIT staff of any issues.

When there is a critical problem that significantly impacts customers' ability to use the cluster, CUIT staff will respond within **3 business hours** to begin the process of identifying and resolving the problem.

CUIT staff will keep all HPC users notified of problems, scope and estimated length of outage, and problem resolution via email to hpc user mailing lists as necessary, and will issue a CUIT service alert as needed.

## ***Other Problems***

Less critical problems are those where the cluster is functioning, but some component has an error, for example, when a single execute server goes down.

For these problems, including application software problems, CUIT staff will respond within **two (2) business days**.  “Business hours” refers to M-F, 9 AM to 5 PM, excluding University holidays.

If necessary, CUIT will then notify system users of any problem and its resolution, issuing a CUIT service alert if needed.

# **User Support**

Users who encounter problems with the HPC cluster, or who have requests concerning software configuration or updates should contact CUIT by emailing [hpc-support@columbia.edu](mailto:hpc-support@columbia.edu) for help.

CUIT provides online [user documentation](https://columbiauniversity.atlassian.net/wiki/spaces/rcs) for the system.

# **Problem Escalation**

In the event that ordinary methods of communication outlined in this SLA prove insufficient, the following contacts can to be used to escalate the problem:

**Max Shortte**, High Performance Computing Manager

[ms6472@columbia.edu](mailto:ms6472@columbia.edu)

**Halayn Hescock**, Senior Director, CUIT Research Services

[hh276@columbia.edu](mailto:hh276@columbia.edu)

**Maneesha Aggarwal**, AVP, Academic, Emerging Technologies & Research Services

[maneesha@columbia.edu](mailto:maneesha@columbia.edu)

**Signatures of Approval**

By signing below, all parties agree to the terms and conditions described in this Agreement.

*CUIT Executive Sponsors*

*Halayn Hescock, Senior Director, Research Services Date*

*Maneesha Aggarwal, AVP Academic, Emerging Technologies, & Research Services*

*Alex Urban, Chair Date*, *Shared Research Computing Policy Advisory Committee*
