## Implementation of RLWM task (Collins and Frank) in ACT-R

### Model 1: Simple RL model
This model relies on two parameters - learning rate and *temperature*. Responses are selected based on reward outcome. 

### Model 2: Memory based model without RL
This model relies on 'memory' of previous experience of the state and its associated outcome. It relies on spreading activation, memory decay rate and retrieval noise. 

### Model 3: Integrated Memory and RL - meta RL
This model integrates models 1 and 2 with a meta-RL system that selects the sub-system to use for each trial. 

### Model 4: Integrated Memory and RL - Explicit bias
This model integrates models 1 and 2 and introduces a new parameter that can be explicitly set to bias learning using  either the RL or Memory sub-system. 