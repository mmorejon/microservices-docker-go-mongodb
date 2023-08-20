// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go k8s.io/api/apps/v1

package v1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/util/intstr"
	"k8s.io/apimachinery/pkg/runtime"
)

#ControllerRevisionHashLabelKey: "controller-revision-hash"
#StatefulSetRevisionLabel:       "controller-revision-hash"
#DeprecatedRollbackTo:           "deprecated.deployment.rollback.to"
#DeprecatedTemplateGeneration:   "deprecated.daemonset.template.generation"
#StatefulSetPodNameLabel:        "statefulset.kubernetes.io/pod-name"

// StatefulSet represents a set of pods with consistent identities.
// Identities are defined as:
//  - Network: A single stable DNS and hostname.
//  - Storage: As many VolumeClaims as requested.
// The StatefulSet guarantees that a given network identity will always
// map to the same storage identity.
#StatefulSet: {
	metav1.#TypeMeta

	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// Spec defines the desired identities of pods in this set.
	// +optional
	spec?: #StatefulSetSpec @go(Spec) @protobuf(2,bytes,opt)

	// Status is the current status of Pods in this StatefulSet. This data
	// may be out of date by some window of time.
	// +optional
	status?: #StatefulSetStatus @go(Status) @protobuf(3,bytes,opt)
}

// PodManagementPolicyType defines the policy for creating pods under a stateful set.
#PodManagementPolicyType: string // #enumPodManagementPolicyType

#enumPodManagementPolicyType:
	#OrderedReadyPodManagement |
	#ParallelPodManagement

// OrderedReadyPodManagement will create pods in strictly increasing order on
// scale up and strictly decreasing order on scale down, progressing only when
// the previous pod is ready or terminated. At most one pod will be changed
// at any time.
#OrderedReadyPodManagement: #PodManagementPolicyType & "OrderedReady"

// ParallelPodManagement will create and delete pods as soon as the stateful set
// replica count is changed, and will not wait for pods to be ready or complete
// termination.
#ParallelPodManagement: #PodManagementPolicyType & "Parallel"

// StatefulSetUpdateStrategy indicates the strategy that the StatefulSet
// controller will use to perform updates. It includes any additional parameters
// necessary to perform the update for the indicated strategy.
#StatefulSetUpdateStrategy: {
	// Type indicates the type of the StatefulSetUpdateStrategy.
	// Default is RollingUpdate.
	// +optional
	type?: #StatefulSetUpdateStrategyType @go(Type) @protobuf(1,bytes,opt,casttype=StatefulSetStrategyType)

	// RollingUpdate is used to communicate parameters when Type is RollingUpdateStatefulSetStrategyType.
	// +optional
	rollingUpdate?: null | #RollingUpdateStatefulSetStrategy @go(RollingUpdate,*RollingUpdateStatefulSetStrategy) @protobuf(2,bytes,opt)
}

// StatefulSetUpdateStrategyType is a string enumeration type that enumerates
// all possible update strategies for the StatefulSet controller.
#StatefulSetUpdateStrategyType: string // #enumStatefulSetUpdateStrategyType

#enumStatefulSetUpdateStrategyType:
	#RollingUpdateStatefulSetStrategyType |
	#OnDeleteStatefulSetStrategyType

// RollingUpdateStatefulSetStrategyType indicates that update will be
// applied to all Pods in the StatefulSet with respect to the StatefulSet
// ordering constraints. When a scale operation is performed with this
// strategy, new Pods will be created from the specification version indicated
// by the StatefulSet's updateRevision.
#RollingUpdateStatefulSetStrategyType: #StatefulSetUpdateStrategyType & "RollingUpdate"

// OnDeleteStatefulSetStrategyType triggers the legacy behavior. Version
// tracking and ordered rolling restarts are disabled. Pods are recreated
// from the StatefulSetSpec when they are manually deleted. When a scale
// operation is performed with this strategy,specification version indicated
// by the StatefulSet's currentRevision.
#OnDeleteStatefulSetStrategyType: #StatefulSetUpdateStrategyType & "OnDelete"

// RollingUpdateStatefulSetStrategy is used to communicate parameter for RollingUpdateStatefulSetStrategyType.
#RollingUpdateStatefulSetStrategy: {
	// Partition indicates the ordinal at which the StatefulSet should be
	// partitioned.
	// Default value is 0.
	// +optional
	partition?: null | int32 @go(Partition,*int32) @protobuf(1,varint,opt)
}

// A StatefulSetSpec is the specification of a StatefulSet.
#StatefulSetSpec: {
	// replicas is the desired number of replicas of the given Template.
	// These are replicas in the sense that they are instantiations of the
	// same Template, but individual replicas also have a consistent identity.
	// If unspecified, defaults to 1.
	// TODO: Consider a rename of this field.
	// +optional
	replicas?: null | int32 @go(Replicas,*int32) @protobuf(1,varint,opt)

	// selector is a label query over pods that should match the replica count.
	// It must match the pod template's labels.
	// More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors
	selector?: null | metav1.#LabelSelector @go(Selector,*metav1.LabelSelector) @protobuf(2,bytes,opt)

	// template is the object that describes the pod that will be created if
	// insufficient replicas are detected. Each pod stamped out by the StatefulSet
	// will fulfill this Template, but have a unique identity from the rest
	// of the StatefulSet.
	template: v1.#PodTemplateSpec @go(Template) @protobuf(3,bytes,opt)

	// volumeClaimTemplates is a list of claims that pods are allowed to reference.
	// The StatefulSet controller is responsible for mapping network identities to
	// claims in a way that maintains the identity of a pod. Every claim in
	// this list must have at least one matching (by name) volumeMount in one
	// container in the template. A claim in this list takes precedence over
	// any volumes in the template, with the same name.
	// TODO: Define the behavior if a claim already exists with the same name.
	// +optional
	volumeClaimTemplates?: [...v1.#PersistentVolumeClaim] @go(VolumeClaimTemplates,[]v1.PersistentVolumeClaim) @protobuf(4,bytes,rep)

	// serviceName is the name of the service that governs this StatefulSet.
	// This service must exist before the StatefulSet, and is responsible for
	// the network identity of the set. Pods get DNS/hostnames that follow the
	// pattern: pod-specific-string.serviceName.default.svc.cluster.local
	// where "pod-specific-string" is managed by the StatefulSet controller.
	serviceName: string @go(ServiceName) @protobuf(5,bytes,opt)

	// podManagementPolicy controls how pods are created during initial scale up,
	// when replacing pods on nodes, or when scaling down. The default policy is
	// `OrderedReady`, where pods are created in increasing order (pod-0, then
	// pod-1, etc) and the controller will wait until each pod is ready before
	// continuing. When scaling down, the pods are removed in the opposite order.
	// The alternative policy is `Parallel` which will create pods in parallel
	// to match the desired scale without waiting, and on scale down will delete
	// all pods at once.
	// +optional
	podManagementPolicy?: #PodManagementPolicyType @go(PodManagementPolicy) @protobuf(6,bytes,opt,casttype=PodManagementPolicyType)

	// updateStrategy indicates the StatefulSetUpdateStrategy that will be
	// employed to update Pods in the StatefulSet when a revision is made to
	// Template.
	updateStrategy?: #StatefulSetUpdateStrategy @go(UpdateStrategy) @protobuf(7,bytes,opt)

	// revisionHistoryLimit is the maximum number of revisions that will
	// be maintained in the StatefulSet's revision history. The revision history
	// consists of all revisions not represented by a currently applied
	// StatefulSetSpec version. The default value is 10.
	revisionHistoryLimit?: null | int32 @go(RevisionHistoryLimit,*int32) @protobuf(8,varint,opt)
}

// StatefulSetStatus represents the current state of a StatefulSet.
#StatefulSetStatus: {
	// observedGeneration is the most recent generation observed for this StatefulSet. It corresponds to the
	// StatefulSet's generation, which is updated on mutation by the API Server.
	// +optional
	observedGeneration?: int64 @go(ObservedGeneration) @protobuf(1,varint,opt)

	// replicas is the number of Pods created by the StatefulSet controller.
	replicas: int32 @go(Replicas) @protobuf(2,varint,opt)

	// readyReplicas is the number of Pods created by the StatefulSet controller that have a Ready Condition.
	readyReplicas?: int32 @go(ReadyReplicas) @protobuf(3,varint,opt)

	// currentReplicas is the number of Pods created by the StatefulSet controller from the StatefulSet version
	// indicated by currentRevision.
	currentReplicas?: int32 @go(CurrentReplicas) @protobuf(4,varint,opt)

	// updatedReplicas is the number of Pods created by the StatefulSet controller from the StatefulSet version
	// indicated by updateRevision.
	updatedReplicas?: int32 @go(UpdatedReplicas) @protobuf(5,varint,opt)

	// currentRevision, if not empty, indicates the version of the StatefulSet used to generate Pods in the
	// sequence [0,currentReplicas).
	currentRevision?: string @go(CurrentRevision) @protobuf(6,bytes,opt)

	// updateRevision, if not empty, indicates the version of the StatefulSet used to generate Pods in the sequence
	// [replicas-updatedReplicas,replicas)
	updateRevision?: string @go(UpdateRevision) @protobuf(7,bytes,opt)

	// collisionCount is the count of hash collisions for the StatefulSet. The StatefulSet controller
	// uses this field as a collision avoidance mechanism when it needs to create the name for the
	// newest ControllerRevision.
	// +optional
	collisionCount?: null | int32 @go(CollisionCount,*int32) @protobuf(9,varint,opt)

	// Represents the latest available observations of a statefulset's current state.
	// +optional
	// +patchMergeKey=type
	// +patchStrategy=merge
	conditions?: [...#StatefulSetCondition] @go(Conditions,[]StatefulSetCondition) @protobuf(10,bytes,rep)
}

#StatefulSetConditionType: string

// StatefulSetCondition describes the state of a statefulset at a certain point.
#StatefulSetCondition: {
	// Type of statefulset condition.
	type: #StatefulSetConditionType @go(Type) @protobuf(1,bytes,opt,casttype=StatefulSetConditionType)

	// Status of the condition, one of True, False, Unknown.
	status: v1.#ConditionStatus @go(Status) @protobuf(2,bytes,opt,casttype=k8s.io/api/core/v1.ConditionStatus)

	// Last time the condition transitioned from one status to another.
	// +optional
	lastTransitionTime?: metav1.#Time @go(LastTransitionTime) @protobuf(3,bytes,opt)

	// The reason for the condition's last transition.
	// +optional
	reason?: string @go(Reason) @protobuf(4,bytes,opt)

	// A human readable message indicating details about the transition.
	// +optional
	message?: string @go(Message) @protobuf(5,bytes,opt)
}

// StatefulSetList is a collection of StatefulSets.
#StatefulSetList: {
	metav1.#TypeMeta

	// +optional
	metadata?: metav1.#ListMeta @go(ListMeta) @protobuf(1,bytes,opt)
	items: [...#StatefulSet] @go(Items,[]StatefulSet) @protobuf(2,bytes,rep)
}

// Deployment enables declarative updates for Pods and ReplicaSets.
#Deployment: {
	metav1.#TypeMeta

	// Standard object metadata.
	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// Specification of the desired behavior of the Deployment.
	// +optional
	spec?: #DeploymentSpec @go(Spec) @protobuf(2,bytes,opt)

	// Most recently observed status of the Deployment.
	// +optional
	status?: #DeploymentStatus @go(Status) @protobuf(3,bytes,opt)
}

// DeploymentSpec is the specification of the desired behavior of the Deployment.
#DeploymentSpec: {
	// Number of desired pods. This is a pointer to distinguish between explicit
	// zero and not specified. Defaults to 1.
	// +optional
	replicas?: null | int32 @go(Replicas,*int32) @protobuf(1,varint,opt)

	// Label selector for pods. Existing ReplicaSets whose pods are
	// selected by this will be the ones affected by this deployment.
	// It must match the pod template's labels.
	selector?: null | metav1.#LabelSelector @go(Selector,*metav1.LabelSelector) @protobuf(2,bytes,opt)

	// Template describes the pods that will be created.
	template: v1.#PodTemplateSpec @go(Template) @protobuf(3,bytes,opt)

	// The deployment strategy to use to replace existing pods with new ones.
	// +optional
	// +patchStrategy=retainKeys
	strategy?: #DeploymentStrategy @go(Strategy) @protobuf(4,bytes,opt)

	// Minimum number of seconds for which a newly created pod should be ready
	// without any of its container crashing, for it to be considered available.
	// Defaults to 0 (pod will be considered available as soon as it is ready)
	// +optional
	minReadySeconds?: int32 @go(MinReadySeconds) @protobuf(5,varint,opt)

	// The number of old ReplicaSets to retain to allow rollback.
	// This is a pointer to distinguish between explicit zero and not specified.
	// Defaults to 10.
	// +optional
	revisionHistoryLimit?: null | int32 @go(RevisionHistoryLimit,*int32) @protobuf(6,varint,opt)

	// Indicates that the deployment is paused.
	// +optional
	paused?: bool @go(Paused) @protobuf(7,varint,opt)

	// The maximum time in seconds for a deployment to make progress before it
	// is considered to be failed. The deployment controller will continue to
	// process failed deployments and a condition with a ProgressDeadlineExceeded
	// reason will be surfaced in the deployment status. Note that progress will
	// not be estimated during the time a deployment is paused. Defaults to 600s.
	progressDeadlineSeconds?: null | int32 @go(ProgressDeadlineSeconds,*int32) @protobuf(9,varint,opt)
}

// DefaultDeploymentUniqueLabelKey is the default key of the selector that is added
// to existing ReplicaSets (and label key that is added to its pods) to prevent the existing ReplicaSets
// to select new pods (and old pods being select by new ReplicaSet).
#DefaultDeploymentUniqueLabelKey: "pod-template-hash"

// DeploymentStrategy describes how to replace existing pods with new ones.
#DeploymentStrategy: {
	// Type of deployment. Can be "Recreate" or "RollingUpdate". Default is RollingUpdate.
	// +optional
	type?: #DeploymentStrategyType @go(Type) @protobuf(1,bytes,opt,casttype=DeploymentStrategyType)

	// Rolling update config params. Present only if DeploymentStrategyType =
	// RollingUpdate.
	//---
	// TODO: Update this to follow our convention for oneOf, whatever we decide it
	// to be.
	// +optional
	rollingUpdate?: null | #RollingUpdateDeployment @go(RollingUpdate,*RollingUpdateDeployment) @protobuf(2,bytes,opt)
}

#DeploymentStrategyType: string // #enumDeploymentStrategyType

#enumDeploymentStrategyType:
	#RecreateDeploymentStrategyType |
	#RollingUpdateDeploymentStrategyType

// Kill all existing pods before creating new ones.
#RecreateDeploymentStrategyType: #DeploymentStrategyType & "Recreate"

// Replace the old ReplicaSets by new one using rolling update i.e gradually scale down the old ReplicaSets and scale up the new one.
#RollingUpdateDeploymentStrategyType: #DeploymentStrategyType & "RollingUpdate"

// Spec to control the desired behavior of rolling update.
#RollingUpdateDeployment: {
	// The maximum number of pods that can be unavailable during the update.
	// Value can be an absolute number (ex: 5) or a percentage of desired pods (ex: 10%).
	// Absolute number is calculated from percentage by rounding down.
	// This can not be 0 if MaxSurge is 0.
	// Defaults to 25%.
	// Example: when this is set to 30%, the old ReplicaSet can be scaled down to 70% of desired pods
	// immediately when the rolling update starts. Once new pods are ready, old ReplicaSet
	// can be scaled down further, followed by scaling up the new ReplicaSet, ensuring
	// that the total number of pods available at all times during the update is at
	// least 70% of desired pods.
	// +optional
	maxUnavailable?: null | intstr.#IntOrString @go(MaxUnavailable,*intstr.IntOrString) @protobuf(1,bytes,opt)

	// The maximum number of pods that can be scheduled above the desired number of
	// pods.
	// Value can be an absolute number (ex: 5) or a percentage of desired pods (ex: 10%).
	// This can not be 0 if MaxUnavailable is 0.
	// Absolute number is calculated from percentage by rounding up.
	// Defaults to 25%.
	// Example: when this is set to 30%, the new ReplicaSet can be scaled up immediately when
	// the rolling update starts, such that the total number of old and new pods do not exceed
	// 130% of desired pods. Once old pods have been killed,
	// new ReplicaSet can be scaled up further, ensuring that total number of pods running
	// at any time during the update is at most 130% of desired pods.
	// +optional
	maxSurge?: null | intstr.#IntOrString @go(MaxSurge,*intstr.IntOrString) @protobuf(2,bytes,opt)
}

// DeploymentStatus is the most recently observed status of the Deployment.
#DeploymentStatus: {
	// The generation observed by the deployment controller.
	// +optional
	observedGeneration?: int64 @go(ObservedGeneration) @protobuf(1,varint,opt)

	// Total number of non-terminated pods targeted by this deployment (their labels match the selector).
	// +optional
	replicas?: int32 @go(Replicas) @protobuf(2,varint,opt)

	// Total number of non-terminated pods targeted by this deployment that have the desired template spec.
	// +optional
	updatedReplicas?: int32 @go(UpdatedReplicas) @protobuf(3,varint,opt)

	// Total number of ready pods targeted by this deployment.
	// +optional
	readyReplicas?: int32 @go(ReadyReplicas) @protobuf(7,varint,opt)

	// Total number of available pods (ready for at least minReadySeconds) targeted by this deployment.
	// +optional
	availableReplicas?: int32 @go(AvailableReplicas) @protobuf(4,varint,opt)

	// Total number of unavailable pods targeted by this deployment. This is the total number of
	// pods that are still required for the deployment to have 100% available capacity. They may
	// either be pods that are running but not yet available or pods that still have not been created.
	// +optional
	unavailableReplicas?: int32 @go(UnavailableReplicas) @protobuf(5,varint,opt)

	// Represents the latest available observations of a deployment's current state.
	// +patchMergeKey=type
	// +patchStrategy=merge
	conditions?: [...#DeploymentCondition] @go(Conditions,[]DeploymentCondition) @protobuf(6,bytes,rep)

	// Count of hash collisions for the Deployment. The Deployment controller uses this
	// field as a collision avoidance mechanism when it needs to create the name for the
	// newest ReplicaSet.
	// +optional
	collisionCount?: null | int32 @go(CollisionCount,*int32) @protobuf(8,varint,opt)
}

#DeploymentConditionType: string // #enumDeploymentConditionType

#enumDeploymentConditionType:
	#DeploymentAvailable |
	#DeploymentProgressing |
	#DeploymentReplicaFailure

// Available means the deployment is available, ie. at least the minimum available
// replicas required are up and running for at least minReadySeconds.
#DeploymentAvailable: #DeploymentConditionType & "Available"

// Progressing means the deployment is progressing. Progress for a deployment is
// considered when a new replica set is created or adopted, and when new pods scale
// up or old pods scale down. Progress is not estimated for paused deployments or
// when progressDeadlineSeconds is not specified.
#DeploymentProgressing: #DeploymentConditionType & "Progressing"

// ReplicaFailure is added in a deployment when one of its pods fails to be created
// or deleted.
#DeploymentReplicaFailure: #DeploymentConditionType & "ReplicaFailure"

// DeploymentCondition describes the state of a deployment at a certain point.
#DeploymentCondition: {
	// Type of deployment condition.
	type: #DeploymentConditionType @go(Type) @protobuf(1,bytes,opt,casttype=DeploymentConditionType)

	// Status of the condition, one of True, False, Unknown.
	status: v1.#ConditionStatus @go(Status) @protobuf(2,bytes,opt,casttype=k8s.io/api/core/v1.ConditionStatus)

	// The last time this condition was updated.
	lastUpdateTime?: metav1.#Time @go(LastUpdateTime) @protobuf(6,bytes,opt)

	// Last time the condition transitioned from one status to another.
	lastTransitionTime?: metav1.#Time @go(LastTransitionTime) @protobuf(7,bytes,opt)

	// The reason for the condition's last transition.
	reason?: string @go(Reason) @protobuf(4,bytes,opt)

	// A human readable message indicating details about the transition.
	message?: string @go(Message) @protobuf(5,bytes,opt)
}

// DeploymentList is a list of Deployments.
#DeploymentList: {
	metav1.#TypeMeta

	// Standard list metadata.
	// +optional
	metadata?: metav1.#ListMeta @go(ListMeta) @protobuf(1,bytes,opt)

	// Items is the list of Deployments.
	items: [...#Deployment] @go(Items,[]Deployment) @protobuf(2,bytes,rep)
}

// DaemonSetUpdateStrategy is a struct used to control the update strategy for a DaemonSet.
#DaemonSetUpdateStrategy: {
	// Type of daemon set update. Can be "RollingUpdate" or "OnDelete". Default is RollingUpdate.
	// +optional
	type?: #DaemonSetUpdateStrategyType @go(Type) @protobuf(1,bytes,opt)

	// Rolling update config params. Present only if type = "RollingUpdate".
	//---
	// TODO: Update this to follow our convention for oneOf, whatever we decide it
	// to be. Same as Deployment `strategy.rollingUpdate`.
	// See https://github.com/kubernetes/kubernetes/issues/35345
	// +optional
	rollingUpdate?: null | #RollingUpdateDaemonSet @go(RollingUpdate,*RollingUpdateDaemonSet) @protobuf(2,bytes,opt)
}

#DaemonSetUpdateStrategyType: string // #enumDaemonSetUpdateStrategyType

#enumDaemonSetUpdateStrategyType:
	#RollingUpdateDaemonSetStrategyType |
	#OnDeleteDaemonSetStrategyType

// Replace the old daemons by new ones using rolling update i.e replace them on each node one after the other.
#RollingUpdateDaemonSetStrategyType: #DaemonSetUpdateStrategyType & "RollingUpdate"

// Replace the old daemons only when it's killed
#OnDeleteDaemonSetStrategyType: #DaemonSetUpdateStrategyType & "OnDelete"

// Spec to control the desired behavior of daemon set rolling update.
#RollingUpdateDaemonSet: {
	// The maximum number of DaemonSet pods that can be unavailable during the
	// update. Value can be an absolute number (ex: 5) or a percentage of total
	// number of DaemonSet pods at the start of the update (ex: 10%). Absolute
	// number is calculated from percentage by rounding up.
	// This cannot be 0.
	// Default value is 1.
	// Example: when this is set to 30%, at most 30% of the total number of nodes
	// that should be running the daemon pod (i.e. status.desiredNumberScheduled)
	// can have their pods stopped for an update at any given
	// time. The update starts by stopping at most 30% of those DaemonSet pods
	// and then brings up new DaemonSet pods in their place. Once the new pods
	// are available, it then proceeds onto other DaemonSet pods, thus ensuring
	// that at least 70% of original number of DaemonSet pods are available at
	// all times during the update.
	// +optional
	maxUnavailable?: null | intstr.#IntOrString @go(MaxUnavailable,*intstr.IntOrString) @protobuf(1,bytes,opt)
}

// DaemonSetSpec is the specification of a daemon set.
#DaemonSetSpec: {
	// A label query over pods that are managed by the daemon set.
	// Must match in order to be controlled.
	// It must match the pod template's labels.
	// More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors
	selector?: null | metav1.#LabelSelector @go(Selector,*metav1.LabelSelector) @protobuf(1,bytes,opt)

	// An object that describes the pod that will be created.
	// The DaemonSet will create exactly one copy of this pod on every node
	// that matches the template's node selector (or on every node if no node
	// selector is specified).
	// More info: https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller#pod-template
	template: v1.#PodTemplateSpec @go(Template) @protobuf(2,bytes,opt)

	// An update strategy to replace existing DaemonSet pods with new pods.
	// +optional
	updateStrategy?: #DaemonSetUpdateStrategy @go(UpdateStrategy) @protobuf(3,bytes,opt)

	// The minimum number of seconds for which a newly created DaemonSet pod should
	// be ready without any of its container crashing, for it to be considered
	// available. Defaults to 0 (pod will be considered available as soon as it
	// is ready).
	// +optional
	minReadySeconds?: int32 @go(MinReadySeconds) @protobuf(4,varint,opt)

	// The number of old history to retain to allow rollback.
	// This is a pointer to distinguish between explicit zero and not specified.
	// Defaults to 10.
	// +optional
	revisionHistoryLimit?: null | int32 @go(RevisionHistoryLimit,*int32) @protobuf(6,varint,opt)
}

// DaemonSetStatus represents the current status of a daemon set.
#DaemonSetStatus: {
	// The number of nodes that are running at least 1
	// daemon pod and are supposed to run the daemon pod.
	// More info: https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/
	currentNumberScheduled: int32 @go(CurrentNumberScheduled) @protobuf(1,varint,opt)

	// The number of nodes that are running the daemon pod, but are
	// not supposed to run the daemon pod.
	// More info: https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/
	numberMisscheduled: int32 @go(NumberMisscheduled) @protobuf(2,varint,opt)

	// The total number of nodes that should be running the daemon
	// pod (including nodes correctly running the daemon pod).
	// More info: https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/
	desiredNumberScheduled: int32 @go(DesiredNumberScheduled) @protobuf(3,varint,opt)

	// The number of nodes that should be running the daemon pod and have one
	// or more of the daemon pod running and ready.
	numberReady: int32 @go(NumberReady) @protobuf(4,varint,opt)

	// The most recent generation observed by the daemon set controller.
	// +optional
	observedGeneration?: int64 @go(ObservedGeneration) @protobuf(5,varint,opt)

	// The total number of nodes that are running updated daemon pod
	// +optional
	updatedNumberScheduled?: int32 @go(UpdatedNumberScheduled) @protobuf(6,varint,opt)

	// The number of nodes that should be running the
	// daemon pod and have one or more of the daemon pod running and
	// available (ready for at least spec.minReadySeconds)
	// +optional
	numberAvailable?: int32 @go(NumberAvailable) @protobuf(7,varint,opt)

	// The number of nodes that should be running the
	// daemon pod and have none of the daemon pod running and available
	// (ready for at least spec.minReadySeconds)
	// +optional
	numberUnavailable?: int32 @go(NumberUnavailable) @protobuf(8,varint,opt)

	// Count of hash collisions for the DaemonSet. The DaemonSet controller
	// uses this field as a collision avoidance mechanism when it needs to
	// create the name for the newest ControllerRevision.
	// +optional
	collisionCount?: null | int32 @go(CollisionCount,*int32) @protobuf(9,varint,opt)

	// Represents the latest available observations of a DaemonSet's current state.
	// +optional
	// +patchMergeKey=type
	// +patchStrategy=merge
	conditions?: [...#DaemonSetCondition] @go(Conditions,[]DaemonSetCondition) @protobuf(10,bytes,rep)
}

#DaemonSetConditionType: string

// DaemonSetCondition describes the state of a DaemonSet at a certain point.
#DaemonSetCondition: {
	// Type of DaemonSet condition.
	type: #DaemonSetConditionType @go(Type) @protobuf(1,bytes,opt,casttype=DaemonSetConditionType)

	// Status of the condition, one of True, False, Unknown.
	status: v1.#ConditionStatus @go(Status) @protobuf(2,bytes,opt,casttype=k8s.io/api/core/v1.ConditionStatus)

	// Last time the condition transitioned from one status to another.
	// +optional
	lastTransitionTime?: metav1.#Time @go(LastTransitionTime) @protobuf(3,bytes,opt)

	// The reason for the condition's last transition.
	// +optional
	reason?: string @go(Reason) @protobuf(4,bytes,opt)

	// A human readable message indicating details about the transition.
	// +optional
	message?: string @go(Message) @protobuf(5,bytes,opt)
}

// DaemonSet represents the configuration of a daemon set.
#DaemonSet: {
	metav1.#TypeMeta

	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// The desired behavior of this daemon set.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	spec?: #DaemonSetSpec @go(Spec) @protobuf(2,bytes,opt)

	// The current status of this daemon set. This data may be
	// out of date by some window of time.
	// Populated by the system.
	// Read-only.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	status?: #DaemonSetStatus @go(Status) @protobuf(3,bytes,opt)
}

// DefaultDaemonSetUniqueLabelKey is the default label key that is added
// to existing DaemonSet pods to distinguish between old and new
// DaemonSet pods during DaemonSet template updates.
#DefaultDaemonSetUniqueLabelKey: "controller-revision-hash"

// DaemonSetList is a collection of daemon sets.
#DaemonSetList: {
	metav1.#TypeMeta

	// Standard list metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ListMeta @go(ListMeta) @protobuf(1,bytes,opt)

	// A list of daemon sets.
	items: [...#DaemonSet] @go(Items,[]DaemonSet) @protobuf(2,bytes,rep)
}

// ReplicaSet ensures that a specified number of pod replicas are running at any given time.
#ReplicaSet: {
	metav1.#TypeMeta

	// If the Labels of a ReplicaSet are empty, they are defaulted to
	// be the same as the Pod(s) that the ReplicaSet manages.
	// Standard object's metadata. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// Spec defines the specification of the desired behavior of the ReplicaSet.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	spec?: #ReplicaSetSpec @go(Spec) @protobuf(2,bytes,opt)

	// Status is the most recently observed status of the ReplicaSet.
	// This data may be out of date by some window of time.
	// Populated by the system.
	// Read-only.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	// +optional
	status?: #ReplicaSetStatus @go(Status) @protobuf(3,bytes,opt)
}

// ReplicaSetList is a collection of ReplicaSets.
#ReplicaSetList: {
	metav1.#TypeMeta

	// Standard list metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	// +optional
	metadata?: metav1.#ListMeta @go(ListMeta) @protobuf(1,bytes,opt)

	// List of ReplicaSets.
	// More info: https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller
	items: [...#ReplicaSet] @go(Items,[]ReplicaSet) @protobuf(2,bytes,rep)
}

// ReplicaSetSpec is the specification of a ReplicaSet.
#ReplicaSetSpec: {
	// Replicas is the number of desired replicas.
	// This is a pointer to distinguish between explicit zero and unspecified.
	// Defaults to 1.
	// More info: https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller/#what-is-a-replicationcontroller
	// +optional
	replicas?: null | int32 @go(Replicas,*int32) @protobuf(1,varint,opt)

	// Minimum number of seconds for which a newly created pod should be ready
	// without any of its container crashing, for it to be considered available.
	// Defaults to 0 (pod will be considered available as soon as it is ready)
	// +optional
	minReadySeconds?: int32 @go(MinReadySeconds) @protobuf(4,varint,opt)

	// Selector is a label query over pods that should match the replica count.
	// Label keys and values that must match in order to be controlled by this replica set.
	// It must match the pod template's labels.
	// More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors
	selector?: null | metav1.#LabelSelector @go(Selector,*metav1.LabelSelector) @protobuf(2,bytes,opt)

	// Template is the object that describes the pod that will be created if
	// insufficient replicas are detected.
	// More info: https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller#pod-template
	// +optional
	template?: v1.#PodTemplateSpec @go(Template) @protobuf(3,bytes,opt)
}

// ReplicaSetStatus represents the current status of a ReplicaSet.
#ReplicaSetStatus: {
	// Replicas is the most recently oberved number of replicas.
	// More info: https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller/#what-is-a-replicationcontroller
	replicas: int32 @go(Replicas) @protobuf(1,varint,opt)

	// The number of pods that have labels matching the labels of the pod template of the replicaset.
	// +optional
	fullyLabeledReplicas?: int32 @go(FullyLabeledReplicas) @protobuf(2,varint,opt)

	// The number of ready replicas for this replica set.
	// +optional
	readyReplicas?: int32 @go(ReadyReplicas) @protobuf(4,varint,opt)

	// The number of available replicas (ready for at least minReadySeconds) for this replica set.
	// +optional
	availableReplicas?: int32 @go(AvailableReplicas) @protobuf(5,varint,opt)

	// ObservedGeneration reflects the generation of the most recently observed ReplicaSet.
	// +optional
	observedGeneration?: int64 @go(ObservedGeneration) @protobuf(3,varint,opt)

	// Represents the latest available observations of a replica set's current state.
	// +optional
	// +patchMergeKey=type
	// +patchStrategy=merge
	conditions?: [...#ReplicaSetCondition] @go(Conditions,[]ReplicaSetCondition) @protobuf(6,bytes,rep)
}

#ReplicaSetConditionType: string // #enumReplicaSetConditionType

#enumReplicaSetConditionType:
	#ReplicaSetReplicaFailure

// ReplicaSetReplicaFailure is added in a replica set when one of its pods fails to be created
// due to insufficient quota, limit ranges, pod security policy, node selectors, etc. or deleted
// due to kubelet being down or finalizers are failing.
#ReplicaSetReplicaFailure: #ReplicaSetConditionType & "ReplicaFailure"

// ReplicaSetCondition describes the state of a replica set at a certain point.
#ReplicaSetCondition: {
	// Type of replica set condition.
	type: #ReplicaSetConditionType @go(Type) @protobuf(1,bytes,opt,casttype=ReplicaSetConditionType)

	// Status of the condition, one of True, False, Unknown.
	status: v1.#ConditionStatus @go(Status) @protobuf(2,bytes,opt,casttype=k8s.io/api/core/v1.ConditionStatus)

	// The last time the condition transitioned from one status to another.
	// +optional
	lastTransitionTime?: metav1.#Time @go(LastTransitionTime) @protobuf(3,bytes,opt)

	// The reason for the condition's last transition.
	// +optional
	reason?: string @go(Reason) @protobuf(4,bytes,opt)

	// A human readable message indicating details about the transition.
	// +optional
	message?: string @go(Message) @protobuf(5,bytes,opt)
}

// ControllerRevision implements an immutable snapshot of state data. Clients
// are responsible for serializing and deserializing the objects that contain
// their internal state.
// Once a ControllerRevision has been successfully created, it can not be updated.
// The API Server will fail validation of all requests that attempt to mutate
// the Data field. ControllerRevisions may, however, be deleted. Note that, due to its use by both
// the DaemonSet and StatefulSet controllers for update and rollback, this object is beta. However,
// it may be subject to name and representation changes in future releases, and clients should not
// depend on its stability. It is primarily for internal use by controllers.
#ControllerRevision: {
	metav1.#TypeMeta

	// Standard object's metadata.
	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta) @protobuf(1,bytes,opt)

	// Data is the serialized representation of the state.
	data?: runtime.#RawExtension @go(Data) @protobuf(2,bytes,opt)

	// Revision indicates the revision of the state represented by Data.
	revision: int64 @go(Revision) @protobuf(3,varint,opt)
}

// ControllerRevisionList is a resource containing a list of ControllerRevision objects.
#ControllerRevisionList: {
	metav1.#TypeMeta

	// More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
	// +optional
	metadata?: metav1.#ListMeta @go(ListMeta) @protobuf(1,bytes,opt)

	// Items is the list of ControllerRevisions
	items: [...#ControllerRevision] @go(Items,[]ControllerRevision) @protobuf(2,bytes,rep)
}
