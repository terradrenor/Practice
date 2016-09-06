# Practice-project
==================

Тема практики:
--------------
 - Применение метода empirical hardness model (EHM) для предсказания выполнимости булевых формул и времени работы SAT-солверов
   при построении автоматов методом Ульянцева.

Цель работы:
------------
 - Выяснить, эффективны ли методы, разработанные в [1-2], применимо к задаче, рассматриваемой в [3-4];
 - Особенно интересно, как хорошо удастся предсказывать UNSAT-случаи (когда автомата не существует).

Задачи:
-------
 - Применить методы из [1-2] к задаче из [3]. Для этого следует добавить новые фичи, специфичные для конечных автоматов,
   проверить, улучшает ли это точность предсказания. Например, можно рассмотреть характеристики дерева сценариев и графа
   совместимости. Сгенерировать обучающие данные и обучить модель, проверить ее на тестовой выборке.

Тула для генерации ДКА:
-----------------------
https://github.com/ctlab/DFA-Inductor

Статья про генерацию ДКА:
-------------------------
https://www.researchgate.net/publication/282859676_BFS-based_Symmetry_Breaking_Predicates_for_DFA_Identification

Материалы исследований:
-----------------------
 - https://drive.google.com/file/d/0BwSy2vSmPPfTZXRuWmJyUnM4Njg/edit?usp=sharing [1]
 - https://drive.google.com/file/d/0BwSy2vSmPPfTTXlMVlNySzBrQ1k/edit?usp=sharing [2]
 - http://rain.ifmo.ru/~ulyantsev/papers/2012/2012NTV77UlyantsevTsarev.pdf       [3]
 - http://rain.ifmo.ru/~ulyantsev/papers/2011/2011ICMLAUlyantsevTsarev.pdf       [4]
