6번
    a) 
    ternary relationship은 binary relationship으로 표현 가능하다.
    
    새로만들어지는 entity E는 e_i = (a_i, b_i, c_i)로 표현

    R_A, R_B, R_C = (e_i, )


ternary relationship을 binary relationship으로 표현할라면  6-6 b)처럼 그리면 되는데, E랑 Ra, Rb, Rc 사이랑 total로 연결되야함.

근데 b)에서는 partial이고, 그래서 문제처럼 B랑 C에는 b_2,  c_2가 없는데도, A에서 (e_2, a_2)를 가질 수가 있음.




1. E에 e_2가  있다는 건, R에도 (a_2, b_2 c_2)가 있다는 것을 의미. 

2. ternary relationship을 binary relationship으로 표현할라면  6-6 b)처럼 그리면 되는데, E랑 Ra, Rb, Rc 사이랑 total로 연결되야함.

3. 정상적으로 ternary relationship을 binary relationship으로 표현할라면

A = {a1, a2}
B = {b1, b2}
C = {c1, c2}
R = {(a1, b1, c1), (a2, b2, c2)}

-> 

A = {a1, a2}
B = {b1, b2}
C = {c1, c2}
E = {e1, e2}    e_i = (a_i, b_i, c_i)
R_a = {(e1, a1), (e2, a2)}
R_b = {(e1, b1), (e2, b2)}
R_c = {(e1, c1), (e2, c2)}

이렇게 해주면 되고, 이러면 E와 각 R_a, R_b, R_c 사이도 total이 되서 잘 표현함.

근데 문제에서는 total 표시가 없어서 문제처럼, 막무가내로 A, B, C저렇게 써넣을 수 있음.





결국 두 그림이 표현하는 바가 다르므로 