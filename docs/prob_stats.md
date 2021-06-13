Data list observed by LiDAR  
$$
\bm{z}_{LiDAR} = \{z_i|i=0,1,2,..., N-1\}
$$

Mean value of LiDAR Data  
$$
\mu = \frac{1}{N} \sum_{i=0}^{N-1} z_i
$$

Sampling variance  
$$
\sigma^2 = \frac{1}{N} \sum_{i=0}^{N-1} (z_i - \mu)^2 (N > 0)
$$

Unbiased variance  
$$
\sigma^2 = \frac{1}{N-1} \sum_{i=0}^{N-1} (z_i - \mu)^2 (N > 1)
$$

Gaussian distribution  
Probability density function  
$$
P(a \le z \le b) = \int_a^b p(z) dz \\
p(z) = \frac{1}{\sqrt{2\pi\sigma^2}}exp\{-\frac{(z-u)^2}{2\sigma^2}\}
$$

Cumulative distribution function  
$$
P(z < a) = \int_{-\infty}^a p(z) dz
$$

Expectation value  
$$
\sum_{z=-\infty}^{\infty} z P(z)
$$
$$
\int_{-\infty}^{\infty} z p(z) dz
$$

Conditional probability density function  
$$
p_t(\bm{x}|\bm{x}_0, \bm{u}_1,\bm{u}_2,...,\bm{u}_t, \bm{z}_1,\bm{z}_2,...,\bm{z}_t)
$$
$$
p_t(\bm{x}|\bm{x}_0, \bm{u}_{1:t}, \bm{z}_{1:t})
$$ 

Belief  
$$
b_t(\bm{x})=p_t(\bm{x}|\bm{x}_0, \bm{u}_{1:t}, \bm{z}_{1:t})
$$
Input: $\bm{x}_0, \bm{u}_{1:t}, \bm{z}_{1:t}$  
State Transition Model: $\bm{x}_t \sim p(\bm{x}|\bm{x}_{t-1},\bm{u}_t)$  
Observation Model: $\bm{z}_t \sim p(\bm{z}|\bm{x}_{t})$  

Belief calculation  
Belief distribution after transition  
$$
\hat{b}_t(\bm{x})=p_t(\bm{x}|\bm{x}_0, \bm{u}_{1:t}, \bm{z}_{1:t-1})
$$
$$
\hat{b}_t(\bm{x})=\int_{\bm{x}'\in \chi} p(\bm{x}|\bm{x}',\bm{u}_t) b_{t-1}(\bm{x}') d\bm{x}' = \langle p(\bm{x}|\bm{x}',\bm{u}_t) \rangle_{b_{t-1}(\bm{x}')}
$$

Density at $\bm{x}'$ before transition: $b_{t-1}(\bm{x'})$  

Reflecting observations $\bm{z}_t$  
$$
b_t(\bm{x})=\hat{b}_t(\bm{x}|\bm{z}_t)=\frac{p(\bm{z}_t|\bm{x})\hat{b}_t(\bm{x})}{p(\bm{z}_t)}=\eta p(\bm{z}_t|\bm{x})\hat{b}_t(\bm{x})
$$

Observation model: $p(\bm{z}_t|\bm{x})$  

Observations list: $\bm{z}_t=\{z_{j,t}|j=0,1,...,N_{m-1}\}$

Each observation $z_{j,t}$ is independent:  
$$
b_t(\bm{x})=\eta \hat{b}_t(\bm{x}) \prod_{j=0}^{N_{m-1}} p_j(z_{j,t}|\bm{x})
$$

Conditional Probability  
$$
P(z|t \in 6時台)
$$
$$
P(y|x)
$$

Joint Probability Distribution  
$$
P(t) = \sum_{z}^{} P(z,t)
$$

$$
P(z) = \sum_{t}^{} P(z,t)
$$

$$
P(z|t) = P(z,t)/P(t)
$$

$$
P(z,t) = P(z|t)P(t)
$$
$$
P(x,y) = P(x|y)P(y) = P(y|x)P(x)
$$

Bayes' theorem  
$$
P(x|y) = \frac{P(y|x) P(x)}{P(y)}
$$

$$
P(y) = \sum_{x \in \chi}^{}{P(x,y)}
$$

$$
P(x|y) = \frac{P(y|x)P(x)}{\sum_{x' \in \chi}^{}{P(x',y)}} = \frac{P(y|x)P(x)}{\sum_{x' \in \chi}^{}{P(y|x')P(x')}} = \frac{P(y|x)P(x)}{\langle P(y|x') \rangle_{P(x')}}
$$

$$
P(x|y) = \eta P(y|x) P(x)
$$

Multiple observations  
$$
P(t|z_1, z_2, z_3) = \eta P(z_1, z_2, z_3|t) P(t)
$$

$$
P(t|630, 632, 636) = \eta P(630, 632, 636|t) P(t)
$$

Multiple dimension probability density function  
$$
p(\bm{x}) = \frac{1}{(2\pi)^{\frac{n}{2}} \sqrt{|\Sigma|}} exp\{-\frac{1}{2}(\bm{x}-\bm{\mu})^T\Sigma^{-1}(\bm{x}-\bm{\mu})\}
$$

Covariance matrix  
$$
\Sigma =
\left(
\begin{array}{rr}
\sigma_x^2 & \sigma_{xy} \\
\sigma_{xy} & \sigma_y^2 \\
\end{array}
\right)
$$

Inversed covariance matrix  
$$
\Lambda = \Sigma^{-1} = \frac{1}{\sigma_x^2\sigma_x^2 - \sigma_{xy}^2}
\left(
\begin{array}{rr}
\sigma_y^2 & -\sigma_{xy} \\
-\sigma_{xy} & \sigma_x^2 \\
\end{array}
\right)
$$

$$
\bm{\mu} =
\left(
\begin{array}{c}
19.9 \\
729 \\
\end{array}
\right), \Sigma = 
\left(
\begin{array}{cc}
42.1 & -0.317 \\
-0.317 & 17.7 \\
\end{array}
\right)
$$

2-dimension covariance
$$
\sigma_{xy} = \frac{1}{N-1} \sum_{i=0}^{N-1} (x_i - \mu_x)(y_i - \mu_y)
$$

$$
a(x,y) = \Nu \left[
\bm{\mu} =
\left(
\begin{array}{c}
50 \\
50 \\
\end{array}
\right), \Sigma=
\left(
\begin{array}{c}
50 & 0 \\
0 & 100 \\
\end{array}
\right)\right]
$$
$$
b(x,y) = \Nu \left[
\bm{\mu} =
\left(
\begin{array}{c}
100 \\
50 \\
\end{array}
\right), \Sigma=
\left(
\begin{array}{c}
125 & 0 \\
0 & 25 \\
\end{array}
\right)\right]
$$
$$
c(x,y) = \Nu \left[
\bm{\mu} =
\left(
\begin{array}{c}
150 \\
50 \\
\end{array}
\right), \Sigma=
\left(
\begin{array}{c}
100 & -25\sqrt{3} \\
-25\sqrt{3} & 50 \\
\end{array}
\right)\right]
$$

$$
  \bm{v}_1 = 
  \left(
    \begin{array}{cc}
    -0.87 & 0.5
    \end{array}
  \right)^T, \bm{v}_2 =
  \left(
    \begin{array}{cc}
    -0.5 & -0.87
    \end{array}
  \right)^T
$$

$$
V = 
\left(
    \begin{array}{cc}
    \bm{v}_1 & \bm{v}_2
    \end{array}
  \right)
$$
$$
L = 
\left(
    \begin{array}{cc}
    l_1 & 0 \\
    0 & l_2 \\
    \end{array}
  \right)
$$
$$
\Sigma = VLV^{-1}
$$