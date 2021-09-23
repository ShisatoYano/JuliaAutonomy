Conditional Probability Density Function  
for probabilistic self-localization  
$$
p_t(\bm{x}|\bm{x}_0, \bm{u}_{1:t}, \bm{z}_{1:t})
$$

* Input: $\bm{x}_0, \bm{u}_{1:t}, \bm{z}_{1:t}$  
* State Transition Model: $\bm{x}_t \sim p(\bm{x}|\bm{u}_{1:t}, \bm{z}_{1:t})$  
* Observation Model: $\bm{z}_t \sim p(\bm{z}|\bm{x}_{t})$  

Belief calculation  
Prediction  
$$
\hat{b}_t(\bm{x}) = p_t(\bm{x}|\bm{x}_0, \bm{u}_{1:t}, \bm{z}_{1:t})
$$
$$
\hat{b}_t(\bm{x}) = \int_{\bm{x}'\in\chi}p(\bm{x}|\bm{x}',\bm{u}_t)b_{t-1}(\bm{x}')d\bm{x}' = \bigl< p(\bm{x}|\bm{x}',\bm{u}_t) \bigr>_{b_{t-1}(\bm{x}')}
$$

Update by Bayes' theorem  
$$
b_t(\bm{x}) = \hat{b}_t(\bm{x}|\bm{z}_t) = \frac{p(\bm{z}_t|\bm{x}) \hat{b}(\bm{x})}{p(\bm{z}_t)} = \eta p(\bm{z}_t|\bm{x}) \hat{b}(\bm{x})
$$

Observation model: $p(\bm{z}_t|\bm{x})$  

Observation list:
$$
\bm{z}_t = \{ \bm{z}_{j,t}|j=0,1,...,N_{m-1} \} \\
b_t(\bm{x}) = \eta \hat{b}_t(\bm{x}) \prod_{j=0}^{N_m-1} p_j(\bm{z}_{j,t}|\bm{x})
$$  

State Transition Model  
Noise from Normalized Distribution: $\delta_{ab} \sim N(0, \sigma^2_{ab})$  
Update noise  
$$
\delta^2_{ab}:(\delta'_{ab}\Delta t)^2 = 1:|b|\Delta t \\
\delta'_{ab} = \delta_{ab} \sqrt{|b|/\Delta t}
$$
State Transition  
$$
  \left(
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
$$

Update particle by observation  
Observation Model for Landmark $m_j$: $p_j(\bm{z}_j|\bm{x})$  
Ratio of Likelihood:  
$$
\frac{p_j(\bm{z}_j|\bm{x}^{(i)})}{p_j(\bm{z}_j|\bm{x}^{(k)})}
$$
Likelihood function: $L_j(\bm{x}|\bm{z})=\eta p_j(\bm{z}|\bm{x})$  
Density of belief distribution at each particle's pose  
$$
b_t(\bm{x_t^{(i)}}) = \hat{b}_t(\bm{x_t^{(i)}}|\bm{z}_{j,t}) = \eta p_j(\bm{z}_{j,t}|\bm{x})
$$

test: ![b_t(\mathbf{x}_t^{(i)})
](https://render.githubusercontent.com/render/math?math=%5Clarge+%5Ctextstyle+b_t%28%5Cmathbf%7Bx%7D_t%5E%7B%28i%29%7D%29%0A)