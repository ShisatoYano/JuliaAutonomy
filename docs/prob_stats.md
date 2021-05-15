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