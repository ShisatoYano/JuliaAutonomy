Pose  
$$
  \bm{x} = 
  \left(
    \begin{array}{cc}
    x & y & \theta
    \end{array}
  \right)^T
$$

State Transition($\omega_t=0$)
$$
  \left(
    \begin{array}{c}
      x_t \\
      y_t \\
      \theta_t
    \end{array}
  \right) = 
  \left(
    \begin{array}{c}
      x_{t-1} \\
      y_{t-1} \\
      \theta_{t-1}
    \end{array}
  \right) + 
  \left(
    \begin{array}{c}
      v_t cos\theta_{t-1} \\
      v_t sin\theta_{t-1} \\
      \omega_t
    \end{array}
  \right) \Delta t
$$  

State Transition($\omega_t\neq0$)
$$
  \left(
    \begin{array}{c}
      x_t \\
      y_t \\
      \theta_t
    \end{array}
  \right) = 
  \left(
    \begin{array}{c}
      x_{t-1} \\
      y_{t-1} \\
      \theta_{t-1}
    \end{array}
  \right) + 
  \left(
    \begin{array}{c}
      v_t \omega_t^{-1} \{ sin(\theta_{t-1} + \omega_t \Delta t) - sin\theta_{t-1} \} \\
      v_t \omega_t^{-1} \{ -cos(\theta_{t-1} + \omega_t \Delta t) + cos\theta_{t-1} \} \\
      \omega_t \Delta t
    \end{array}
  \right)
$$

Object coordinate  
$$
\bm{m}_j = 
  \left(
    \begin{array}{cc}
    m_{j,x} & m_{j,y}
    \end{array}
  \right)^T
$$

Map  
$$
\bm{m} = \{m_j|j=0,1,2,...,N_{\bm{m}}-1\}
$$

Observation Equation  
$$
\bm{h}(\bm{x}, \bm{m}_j)
$$