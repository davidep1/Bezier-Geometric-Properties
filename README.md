# Bezier-Geometric-Properties

*This repository contains the official open-source MATLAB implementation accompanying the research paper:*
> **Davide Pellecchia, Luciano Rosati, Francesco Marmo (2026). "Evaluation of high-order moments for plane and solid closed domains bounded by arbitrary-degree Bézier curves and surfaces".** *(Currently under review)*

---

**Bezier-Geometric-Properties** is a toolkit designed for the exact evaluation of geometric properties and arbitrary-order moments (area, volume, static moments, inertia tensors, and $k$-th order tensors for **any** arbitrary integer $k$) for closed 2D and 3D domains.

Unlike standard numerical integration methods that rely on boundary triangulation, polygonal approximations, or internal meshing (e.g., FEM), this code operates directly on the exact parametric boundary representation. By exploiting the Gauss-Green and Divergence theorems, domain integrals are analytically converted into boundary integrals and solved in closed-form.

### Key Features
* **Exact Computation:** Achieves machine-precision accuracy ($\approx 10^{-16}$), eliminating geometric and numerical approximation errors.
* **Truly Arbitrary Order ($k \in \mathbb{N}$):** The implemented formulas are completely general. Users can compute moments of **any** desired rank $k$ without theoretical upper bounds (essential for high-order beam theories, generalized continuum mechanics, and pattern recognition).
* **2D & 3D Support:** Seamlessly handles both planar cross-sections (bounded by Bézier curves) and solid domains (bounded by watertight Bézier surface networks).
* **Heterogeneous Degrees:** Supports boundaries composed of Bézier patches with different polynomial degrees (e.g., linear webs and quadratic fillets in cold-formed steel sections).

### Citing this work
If you use this code in your research, please consider citing our paper. The citation details and the corresponding BibTeX entry will be updated here as soon as the article is officially published and a DOI is assigned.

```bibtex
@article{Pellecchia:2026,
  title={Evaluation of high-order moments for plane and solid closed domains bounded by arbitrary-degree B{\'e}zier curves and surfaces},
  author={Pellecchia, Davide and Rosati, Luciano and Marmo, Francesco},
  journal={Submitted for publication},
  year={2026}
}
