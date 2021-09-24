# Particle Filter

## Monte Carlo Localization
* Method to estimate self-pose by Particle Filter  
* Calculate distribution of particles with State transition/Observation model  
* Distribution of particles represent one of belief  

## Particle

### State transition
* Noise when robot is moving follows gaussian distribution  
* The variance is proportional to amount of movement  
* ![\sigma_{vv}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Csigma_%7Bvv%7D%0A): Standard deviation of distance per 1[m] forward  
* ![\sigma_{v\omega}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Csigma_%7Bv%5Comega%7D%0A): Standard deviation of distance per 1[rad] rotation  
* ![\sigma_{\omega v}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Csigma_%7B%5Comega+v%7D%0A): Standard deviation of direction per 1[m] forward  
* ![\sigma_{\omega \omega}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Csigma_%7B%5Comega+%5Comega%7D%0A): Standard deviation of direction per 1[rad] rotation  
* Drawing amount of noise from gaussian distribution with standard deviation b affects a: ![\delta_{ab} \sim N(0, \sigma^2_{ab})
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cdelta_%7Bab%7D+%5Csim+N%280%2C+%5Csigma%5E2_%7Bab%7D%29%0A)  
* Update amount of noise which is proportional to amount of movement/rotation  
![\begin{align*}
\delta^2_{ab}:(\delta'_{ab}\Delta t)^2 = 1:|b|\Delta t \\
\delta'_{ab} = \delta_{ab} \sqrt{|b|/\Delta t}
\end{align*}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0A%5Cdelta%5E2_%7Bab%7D%3A%28%5Cdelta%27_%7Bab%7D%5CDelta+t%29%5E2+%3D+1%3A%7Cb%7C%5CDelta+t+%5C%5C%0A%5Cdelta%27_%7Bab%7D+%3D+%5Cdelta_%7Bab%7D+%5Csqrt%7B%7Cb%7C%2F%5CDelta+t%7D%0A%5Cend%7Balign%2A%7D%0A)  
* State transition model considering noise  
![\left(
    \begin{array}{c}
      v' \\
      \omega'
    \end{array}
  \right) =
  \left(
    \begin{array}{c}
      v \\
      \omega
    \end{array}
  \right) + 
  \left(
    \begin{array}{c}
      \delta_{vv}\sqrt{|v|/\Delta t} + \delta_{v\omega}\sqrt{|\omega|/\Delta t} \\
      \delta_{\omega v}\sqrt{|v|/\Delta t} + \delta_{\omega \omega}\sqrt{|\omega|/\Delta t}
    \end{array}
  \right)
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cleft%28%0A++++%5Cbegin%7Barray%7D%7Bc%7D%0A++++++v%27+%5C%5C%0A++++++%5Comega%27%0A++++%5Cend%7Barray%7D%0A++%5Cright%29+%3D%0A++%5Cleft%28%0A++++%5Cbegin%7Barray%7D%7Bc%7D%0A++++++v+%5C%5C%0A++++++%5Comega%0A++++%5Cend%7Barray%7D%0A++%5Cright%29+%2B+%0A++%5Cleft%28%0A++++%5Cbegin%7Barray%7D%7Bc%7D%0A++++++%5Cdelta_%7Bvv%7D%5Csqrt%7B%7Cv%7C%2F%5CDelta+t%7D+%2B+%5Cdelta_%7Bv%5Comega%7D%5Csqrt%7B%7C%5Comega%7C%2F%5CDelta+t%7D+%5C%5C%0A++++++%5Cdelta_%7B%5Comega+v%7D%5Csqrt%7B%7Cv%7C%2F%5CDelta+t%7D+%2B+%5Cdelta_%7B%5Comega+%5Comega%7D%5Csqrt%7B%7C%5Comega%7C%2F%5CDelta+t%7D%0A++++%5Cend%7Barray%7D%0A++%5Cright%29%0A)  

### How to adjust parameters of noise
* Calculate variance of pose by multiple robot's movement and rotation simulation  
1. ![\sigma_{\omega v}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Csigma_%7B%5Comega+v%7D%0A): sqrt of value variance of direction is divided by mean of distance  
2. ![\sigma_{vv}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Csigma_%7Bvv%7D%0A): sqrt of value variance of distance is divided by mean of distance  
3. ![\sigma_{\omega \omega}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Csigma_%7B%5Comega+%5Comega%7D%0A): sqrt of value variance of direction is divided by mean of direction  
4. ![\sigma_{v\omega}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Csigma_%7Bv%5Comega%7D%0A): sqrt of value variance of distance is divided by mean of direction  

### Approximation of belief distribution by particle
![P(\mathbf{x}_t^* \in X) = \int_{\mathbf{x} \in X} b_t(\mathbf{x})d\mathbf{x} \approx \frac{1}{N} \sum_{i=0}^{N-1}\delta(\mathbf{x}_t^{(i)} \in X)
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+P%28%5Cmathbf%7Bx%7D_t%5E%2A+%5Cin+X%29+%3D+%5Cint_%7B%5Cmathbf%7Bx%7D+%5Cin+X%7D+b_t%28%5Cmathbf%7Bx%7D%29d%5Cmathbf%7Bx%7D+%5Capprox+%5Cfrac%7B1%7D%7BN%7D+%5Csum_%7Bi%3D0%7D%5E%7BN-1%7D%5Cdelta%28%5Cmathbf%7Bx%7D_t%5E%7B%28i%29%7D+%5Cin+X%29%0A)  

### How to reflect observation to particle
* Observation Model for Landmark ![m_j](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+m_j): ![p_j(\mathbf{z}_j|\mathbf{x})](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+p_j%28%5Cmathbf%7Bz%7D_j%7C%5Cmathbf%7Bx%7D%29)  
* With the above model, we can evaluate which is more plausible, ![\mathbf{x}^{(i)}](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7Bx%7D%5E%7B%28i%29%7D) or ![\mathbf{x}^{(k)}](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7Bx%7D%5E%7B%28k%29%7D)?  

![\frac{p_j(\mathbf{z}_j|\mathbf{x}^{(i)})}{p_j(\mathbf{z}_j|\mathbf{x}^{(k)})}](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cfrac%7Bp_j%28%5Cmathbf%7Bz%7D_j%7C%5Cmathbf%7Bx%7D%5E%7B%28i%29%7D%29%7D%7Bp_j%28%5Cmathbf%7Bz%7D_j%7C%5Cmathbf%7Bx%7D%5E%7B%28k%29%7D%29%7D)  
* This model can be defined as the following Likelihood function  
![L_j(\mathbf{x}|\mathbf{z}) = \eta p_j(\mathbf{z}|\mathbf{x})](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+L_j%28%5Cmathbf%7Bx%7D%7C%5Cmathbf%7Bz%7D%29+%3D+%5Ceta+p_j%28%5Cmathbf%7Bz%7D%7C%5Cmathbf%7Bx%7D%29)  

### Weight of particle
* Particle is defined as a pair of pose and weight: ![\xi_t^{(i)} = (\mathbf{x}_t^{(i)}, w_t^{(i)})
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cxi_t%5E%7B%28i%29%7D+%3D+%28%5Cmathbf%7Bx%7D_t%5E%7B%28i%29%7D%2C+w_t%5E%7B%28i%29%7D%29%0A)  
* Sum of each particle's weight: ![\sum_{i=0}^{N-1} w_t^{(i)} = 1](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Csum_%7Bi%3D0%7D%5E%7BN-1%7D+w_t%5E%7B%28i%29%7D+%3D+1)  
* Update weight by reflecting observation: ![w_t^{(i)} = L_j(\mathbf{x}_t^{(i)}|\mathbf{z}_{j,t})\hat{w}_t^{(i)}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+w_t%5E%7B%28i%29%7D+%3D+L_j%28%5Cmathbf%7Bx%7D_t%5E%7B%28i%29%7D%7C%5Cmathbf%7Bz%7D_%7Bj%2Ct%7D%29%5Chat%7Bw%7D_t%5E%7B%28i%29%7D%0A)  

### Likelihood function  
