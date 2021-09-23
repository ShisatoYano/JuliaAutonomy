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


### How to reflect observation to particle
