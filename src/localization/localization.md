# Self-Localization

## What is Self-Localization?
* To estimate self-pose(position and direction) with observation by sensor.
* Conditional probability density function for self-localization estimation.

* ![p_t(\mathbf{x}|\mathbf{x}_0, \mathbf{u}_{1:t}, \mathbf{z}_{1:t})
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+p_t%28%5Cmathbf%7Bx%7D%7C%5Cmathbf%7Bx%7D_0%2C+%5Cmathbf%7Bu%7D_%7B1%3At%7D%2C+%5Cmathbf%7Bz%7D_%7B1%3At%7D%29%0A)

* Probabilistic self-localization is to resolve this distribution.
* This is called as Belief Distribution.

## Input and Model for Self-Localization
* State: ![\mathbf{x}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7Bx%7D%0A), Control input: ![\mathbf{u}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7Bu%7D%0A), Observation: ![\mathbf{z}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7Bz%7D%0A)
* Input: ![\mathbf{x}_0, \mathbf{u}_{1:t}, \mathbf{z}_{1:t}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7Bx%7D_0%2C+%5Cmathbf%7Bu%7D_%7B1%3At%7D%2C+%5Cmathbf%7Bz%7D_%7B1%3At%7D%0A)
* State Transition Model: ![\mathbf{x}_t \sim p(\mathbf{x}|\mathbf{u}_{1:t}, \mathbf{z}_{1:t})](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7Bx%7D_t+%5Csim+p%28%5Cmathbf%7Bx%7D%7C%5Cmathbf%7Bu%7D_%7B1%3At%7D%2C+%5Cmathbf%7Bz%7D_%7B1%3At%7D%29)
* Observation Model: ![\mathbf{z}_t \sim p(\mathbf{z}|\mathbf{x}_{t})
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7Bz%7D_t+%5Csim+p%28%5Cmathbf%7Bz%7D%7C%5Cmathbf%7Bx%7D_%7Bt%7D%29%0A)

## Update Belief Distribution
* Robot moves from at t-1 to t by ![\mathbf{u}_t
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7Bu%7D_t%0A)  
* And then, Belief distribution transit from ![b_{t-1}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+b_%7Bt-1%7D%0A) to ![\hat{b}_{t}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Chat%7Bb%7D_%7Bt%7D%0A)
* ![\hat{b}_t(\mathbf{x}) = p_t(\mathbf{x}|\mathbf{x}_0, \mathbf{u}_{1:t}, \mathbf{z}_{1:t})
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Chat%7Bb%7D_t%28%5Cmathbf%7Bx%7D%29+%3D+p_t%28%5Cmathbf%7Bx%7D%7C%5Cmathbf%7Bx%7D_0%2C+%5Cmathbf%7Bu%7D_%7B1%3At%7D%2C+%5Cmathbf%7Bz%7D_%7B1%3At%7D%29%0A)
* In this step, observation z has not been input yet
* Sum of density ![b_{t-1}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+b_%7Bt-1%7D%0A) at each pose x' following distribution p
* ![\hat{b}_t(\mathbf{x}) = \int_{\mathbf{x}'\in\chi}p(\mathbf{x}|\mathbf{x}',\mathbf{u}_t)b_{t-1}(\mathbf{x}')d\mathbf{x}'
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Chat%7Bb%7D_t%28%5Cmathbf%7Bx%7D%29+%3D+%5Cint_%7B%5Cmathbf%7Bx%7D%27%5Cin%5Cchi%7Dp%28%5Cmathbf%7Bx%7D%7C%5Cmathbf%7Bx%7D%27%2C%5Cmathbf%7Bu%7D_t%29b_%7Bt-1%7D%28%5Cmathbf%7Bx%7D%27%29d%5Cmathbf%7Bx%7D%27%0A)
* Next step、calculate ![b_t
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+b_t%0A) reflecting observation list ![\mathbf{z}_t
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7Bz%7D_t%0A) to ![\hat{b}_{t}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Chat%7Bb%7D_%7Bt%7D%0A)
* ![b_t(\mathbf{x}) = \hat{b}_t(\mathbf{x}|\mathbf{z}_t) = \frac{p(\mathbf{z}_t|\mathbf{x}) \hat{b}(\mathbf{x})}{p(\mathbf{z}_t)} = \eta p(\mathbf{z}_t|\mathbf{x}) \hat{b}(\mathbf{x})
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+b_t%28%5Cmathbf%7Bx%7D%29+%3D+%5Chat%7Bb%7D_t%28%5Cmathbf%7Bx%7D%7C%5Cmathbf%7Bz%7D_t%29+%3D+%5Cfrac%7Bp%28%5Cmathbf%7Bz%7D_t%7C%5Cmathbf%7Bx%7D%29+%5Chat%7Bb%7D%28%5Cmathbf%7Bx%7D%29%7D%7Bp%28%5Cmathbf%7Bz%7D_t%29%7D+%3D+%5Ceta+p%28%5Cmathbf%7Bz%7D_t%7C%5Cmathbf%7Bx%7D%29+%5Chat%7Bb%7D%28%5Cmathbf%7Bx%7D%29%0A)
* Observation Model: ![p(\mathbf{z}_t|\mathbf{x})
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+p%28%5Cmathbf%7Bz%7D_t%7C%5Cmathbf%7Bx%7D%29%0A)
* When each observation is individual
* ![\mathbf{z}_t = \{ \mathbf{z}_{j,t}|j=0,1,...,N_{m-1} \}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7Bz%7D_t+%3D+%5C%7B+%5Cmathbf%7Bz%7D_%7Bj%2Ct%7D%7Cj%3D0%2C1%2C...%2CN_%7Bm-1%7D+%5C%7D%0A)
* ![b_t(\mathbf{x}) = \eta \hat{b}_t(\mathbf{x}) \prod_{j=0}^{N_m-1} p_j(\mathbf{z}_{j,t}|\mathbf{x})
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+b_t%28%5Cmathbf%7Bx%7D%29+%3D+%5Ceta+%5Chat%7Bb%7D_t%28%5Cmathbf%7Bx%7D%29+%5Cprod_%7Bj%3D0%7D%5E%7BN_m-1%7D+p_j%28%5Cmathbf%7Bz%7D_%7Bj%2Ct%7D%7C%5Cmathbf%7Bx%7D%29%0A)