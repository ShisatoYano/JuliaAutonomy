# Extended Kalman Filter

## Simulation example
![](anime_ekf.gif)  

## Advantage of Kalman Filter
* Probability can be calculated by calculating only Gaussian Distribution  
* This mean that Distribution can be calculated with covariance and average  
* Iteration for a lot of particles like MCL is unnecessary  

## Approximation
* Probability distribution is approximated as Gaussian distribution  
* In addition, state equation and observation equation are linearized  
* This method is called as Extended Kalman Filter  

## Update Belief after movement
* Belief at time t: ![bt = N(\mathbf{\mu}_t, \Sigma_t)
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+bt+%3D+N%28%5Cmathbf%7B%5Cmu%7D_t%2C+%5CSigma_t%29%0A)  
* Approximate input/output of the following equation with only Gaussian distribution  
![\hat{b}_t(\mathbf{x}) = \int_{\mathbf{x}'\in X} p(\mathbf{x}|\mathbf{x}', \mathbf{u}_t) b_{t-1}(\mathbf{x}')d\mathbf{x}'
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Chat%7Bb%7D_t%28%5Cmathbf%7Bx%7D%29+%3D+%5Cint_%7B%5Cmathbf%7Bx%7D%27%5Cin+X%7D+p%28%5Cmathbf%7Bx%7D%7C%5Cmathbf%7Bx%7D%27%2C+%5Cmathbf%7Bu%7D_t%29+b_%7Bt-1%7D%28%5Cmathbf%7Bx%7D%27%29d%5Cmathbf%7Bx%7D%27%0A)  
### Linearize State Transition model
* Input plus noise: ![\mathbf{u}_t' = \mathbf{u}_t + \mathbf{\varepsilon}_{\mathbf{u}}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7Bu%7D_t%27+%3D+%5Cmathbf%7Bu%7D_t+%2B+%5Cmathbf%7B%5Cvarepsilon%7D_%7B%5Cmathbf%7Bu%7D%7D%0A)  
* Noise  
![\mathbf{\varepsilon}_{\mathbf{u}} = \begin{pmatrix}
\delta_{vv}\sqrt{|v|/\Delta t} + \delta_{v\omega}\sqrt{|\omega|/\Delta t} \\
\delta_{\omega v}\sqrt{|v|/\Delta t} + \delta_{\omega \omega}\sqrt{|\omega|/\Delta t}
\end{pmatrix}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7B%5Cvarepsilon%7D_%7B%5Cmathbf%7Bu%7D%7D+%3D+%5Cbegin%7Bpmatrix%7D%0A%5Cdelta_%7Bvv%7D%5Csqrt%7B%7Cv%7C%2F%5CDelta+t%7D+%2B+%5Cdelta_%7Bv%5Comega%7D%5Csqrt%7B%7C%5Comega%7C%2F%5CDelta+t%7D+%5C%5C%0A%5Cdelta_%7B%5Comega+v%7D%5Csqrt%7B%7Cv%7C%2F%5CDelta+t%7D+%2B+%5Cdelta_%7B%5Comega+%5Comega%7D%5Csqrt%7B%7C%5Comega%7C%2F%5CDelta+t%7D%0A%5Cend%7Bpmatrix%7D%0A)  
![\mathbf{\varepsilon}_{\mathbf{u}} = \begin{pmatrix}
\delta_{vv}\sqrt{|v|/\Delta t} \\
 \delta_{v\omega}\sqrt{|\omega|/\Delta t} \\
\delta_{\omega v}\sqrt{|v|/\Delta t} \\
 \delta_{\omega \omega}\sqrt{|\omega|/\Delta t}
\end{pmatrix} \sim N\left[ 0, \begin{pmatrix}
\sigma_{vv}^2 |v_t|/\Delta t & 0 & 0 & 0\\
0 & \sigma_{v\omega}^2 |\omega_t|/\Delta t & 0 & 0 \\
0 & 0 & \sigma_{\omega v}^2 |v_t|/\Delta t & 0 \\
0 & 0 & 0 & \sigma_{\omega \omega}^2 |\omega_t|/\Delta t
\end{pmatrix} \right]
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7B%5Cvarepsilon%7D_%7B%5Cmathbf%7Bu%7D%7D+%3D+%5Cbegin%7Bpmatrix%7D%0A%5Cdelta_%7Bvv%7D%5Csqrt%7B%7Cv%7C%2F%5CDelta+t%7D+%5C%5C%0A+%5Cdelta_%7Bv%5Comega%7D%5Csqrt%7B%7C%5Comega%7C%2F%5CDelta+t%7D+%5C%5C%0A%5Cdelta_%7B%5Comega+v%7D%5Csqrt%7B%7Cv%7C%2F%5CDelta+t%7D+%5C%5C%0A+%5Cdelta_%7B%5Comega+%5Comega%7D%5Csqrt%7B%7C%5Comega%7C%2F%5CDelta+t%7D%0A%5Cend%7Bpmatrix%7D+%5Csim+N%5Cleft%5B+0%2C+%5Cbegin%7Bpmatrix%7D%0A%5Csigma_%7Bvv%7D%5E2+%7Cv_t%7C%2F%5CDelta+t+%26+0+%26+0+%26+0%5C%5C%0A0+%26+%5Csigma_%7Bv%5Comega%7D%5E2+%7C%5Comega_t%7C%2F%5CDelta+t+%26+0+%26+0+%5C%5C%0A0+%26+0+%26+%5Csigma_%7B%5Comega+v%7D%5E2+%7Cv_t%7C%2F%5CDelta+t+%26+0+%5C%5C%0A0+%26+0+%26+0+%26+%5Csigma_%7B%5Comega+%5Comega%7D%5E2+%7C%5Comega_t%7C%2F%5CDelta+t%0A%5Cend%7Bpmatrix%7D+%5Cright%5D%0A)  
* Covariance matrix of input![\mathbf{u}_t = (v_t, \omega_t)^T](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7Bu%7D_t+%3D+%28v_t%2C+%5Comega_t%29%5ET)  
![M_t = \begin{pmatrix}
\sigma_{vv}^2 |v_t|/\Delta t + \sigma_{v\omega}^2 |\omega_t|/\Delta t & 0 \\
0 & \sigma_{\omega v}^2 |v_t|/\Delta t + \sigma_{\omega \omega}^2 |\omega_t|/\Delta t
\end{pmatrix}](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+M_t+%3D+%5Cbegin%7Bpmatrix%7D%0A%5Csigma_%7Bvv%7D%5E2+%7Cv_t%7C%2F%5CDelta+t+%2B+%5Csigma_%7Bv%5Comega%7D%5E2+%7C%5Comega_t%7C%2F%5CDelta+t+%26+0+%5C%5C%0A0+%26+%5Csigma_%7B%5Comega+v%7D%5E2+%7Cv_t%7C%2F%5CDelta+t+%2B+%5Csigma_%7B%5Comega+%5Comega%7D%5E2+%7C%5Comega_t%7C%2F%5CDelta+t%0A%5Cend%7Bpmatrix%7D)  
* Input is generated from the following distribution  
![\mathbf{u}_t' \sim N(\mathbf{u}_t, M_t)](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7Bu%7D_t%27+%5Csim+N%28%5Cmathbf%7Bu%7D_t%2C+M_t%29)  
* Linearize ![\mathbf{x}_t
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7Bx%7D_t%0A) distribution by Taylor expansion  
![\mathbf{x}_t = \mathbf{f}(\mathbf{x}_{t-1}, \mathbf{u}_t') \approx \mathbf{f}(\mathbf{x}_{t-1}, \mathbf{u}_t) + A_t(\mathbf{u}_t' - \mathbf{u}_t)
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+%5Cmathbf%7Bx%7D_t+%3D+%5Cmathbf%7Bf%7D%28%5Cmathbf%7Bx%7D_%7Bt-1%7D%2C+%5Cmathbf%7Bu%7D_t%27%29+%5Capprox+%5Cmathbf%7Bf%7D%28%5Cmathbf%7Bx%7D_%7Bt-1%7D%2C+%5Cmathbf%7Bu%7D_t%29+%2B+A_t%28%5Cmathbf%7Bu%7D_t%27+-+%5Cmathbf%7Bu%7D_t%29%0A)  
* Jacobian matrix about input: ![A_t = \left. \frac{\partial \mathbf{f}}{\partial \mathbf{u}} \right|_{\mathbf{x}=\mathbf{x}_{t-1}, \mathbf{u}=\mathbf{u}_t}
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+A_t+%3D+%5Cleft.+%5Cfrac%7B%5Cpartial+%5Cmathbf%7Bf%7D%7D%7B%5Cpartial+%5Cmathbf%7Bu%7D%7D+%5Cright%7C_%7B%5Cmathbf%7Bx%7D%3D%5Cmathbf%7Bx%7D_%7Bt-1%7D%2C+%5Cmathbf%7Bu%7D%3D%5Cmathbf%7Bu%7D_t%7D%0A)  
* Calculate covariance matrix in ![XY\theta](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+XY%5Ctheta) space  
