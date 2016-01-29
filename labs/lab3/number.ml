<<<<<<< HEAD
type number = Int of int| Float of float

let to_int n = match n with
  |Int -> n
  |_ -> None

let to_float n = match n with
  |Float -> n
  | _ -> None

let float_of_number n = match n with
  |Float -> n
  |Int -> float_of_int n
  |_ -> None
=======
type number = Int of int | Float of float

let to_int n = match n with
| Int a -> Some a
| _ -> None

let to_float n = match n with
| Float a -> Some a
| _ -> None

let float_of_number n = match n with
| Float a -> Some a
| Int b -> Some (float_of_int b)

let (+>) a b = match (a,b) with
| (Int m, Int n) -> Int (m + n)
| (Int m, Float n)|(Float n, Int m) -> Float (n +. float_of_int m)
| (Float m, Float n) -> Float(m +. n)

let ( *> ) a b = match (a,b) with
| (Int m, Int n) -> Int (m * n)
| (Int m, Float n)|(Float n, Int m) -> Float (n *. float_of_int m)
| (Float m, Float n) -> Float(m *. n)

>>>>>>> bc36ad4f78c49152adb1741a01b71f8d1d74e493
