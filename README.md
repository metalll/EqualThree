# EqualThree
Match - 3 ios Game - 70% готово

1 - очередь

1 Блокировка интерфейса пока происходят анимации появления и уничтожения элементов - реализовано<br> 
2 Подсчет ходов  - реализовано <br>
3 Подсчет очков  - реализовано <br>
4 Распознавание ситуации когда у игрока не остается доступных ходов - реализовано<br>
5 Сохранение / загрузка игры - реализовано <br>



2 - очередь

6 Завершение игры в случае невозможности сделать ход - реализовано (см. п. 4)<br>
7 Добавление записи в таблицу рекордов по завершении игры - реализовано(см. п. 6)<br>
8 Подсказка (любой доступный ход) - реализовано <br>
9 Рефакторинг - в процессе <br>


https://github.com/metalll/EqualThree/releases/tag/0.0.1<br>
1. NSDGeneralMenuViewController isNewGame не нужен, вместо него можно просто использовать разные сигвеи для новой игры, и для продолжения<br>
2. Вызовы performSegueWithIdentifier неплохо бы вынести в отдельные функции<br>
3. [UIColor whiteColor] тоже нужно вынести в категорию и правильно обозвать, например [UIColor topBarColor]<br>
4. kIsHasSavedGame - грамматически неправильно; правильно - kHasSavedGame<br>
5. не, movies а moves<br>
6. NSDGameDidFieldEndDeleting -> NSDGameFieldDidEndDeletingNotificaation<br>
7. kNSDCostDeletedItems -> kNSDDeletedItemsCost<br>
8. NSDCostItem -> NSDItemCost<br>
9. replasmentStringSize -> replacementStringSize<br>
10. В следующих функциях вместо i и j использовать NSDIJStruct<br>
    - (CGPoint)xyCoordinatesFromI:(NSInteger)i j:(NSInteger)j;<br>
    - (NSDGameItemView*)createGameItemViewWithFrame:(CGRect)frame type:(NSUInteger)type;<br>
    - (NSDGameItemView*)gameItemViewAtI:(NSInteger)i j:(NSInteger)j type:(NSUInteger)type;<br>
11. self-> перед ivar ставить необязательно<br>
12. Имя ivar-а принято как-то выделять, например символом "_"<br>
13. Сортировать рекорды при каждом обращении к ним не рационально, правильнее было бы сортировать их только при добавлении новой записи<br>
14. Значение isSorted нигде не проверяется<br>
15. Вообще претензии к форматированию кода, местами неправильно проставлены отступы (юзай ctrl+I), нет пробелов там где должны бы быть, (например в таких констру кциях: a = b + c), но самое существенное, это множество непонятных пустых строк.<br>












