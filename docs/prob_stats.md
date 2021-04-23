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
