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