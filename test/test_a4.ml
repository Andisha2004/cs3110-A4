open OUnit2
open Myset

(* Mock implementation of ElementSet for MySetMock *)
module ElementSetMock = struct
  type t = string

  let compare = String.compare
  let to_string s = s
end

module MySetTest = Make (ElementSetMock)

let test_intersection_case_sensitive _ =
  let list1 = [ "CS"; "INFO"; "MATH" ] in
  let list2 = [ "CS"; "BTRY"; "math" ] in
  let set1 =
    List.fold_left
      (fun acc elem -> MySetTest.add elem acc)
      MySetTest.empty list1
  in
  let set2 =
    List.fold_left
      (fun acc elem -> MySetTest.add elem acc)
      MySetTest.empty list2
  in
  let expected = "{CS}" in
  let result = MySetTest.intersection set1 set2 in
  assert_equal expected (MySetTest.to_string result);

  let list3 = [ "apple"; "ORANGE" ] in
  let list4 = [ "APPLE" ] in
  let set3 =
    List.fold_left
      (fun acc elem -> MySetTest.add elem acc)
      MySetTest.empty list3
  in
  let set4 =
    List.fold_left
      (fun acc elem -> MySetTest.add elem acc)
      MySetTest.empty list4
  in
  let expected1 = "{}" in
  let result1 = MySetTest.intersection set3 set4 in
  assert_equal expected1 (MySetTest.to_string result1)

module ElementSetMock1 = struct
  type t = string

  let compare x y =
    String.compare (String.lowercase_ascii x) (String.lowercase_ascii y)

  let to_string s = s
end

module MySetTest1 = Make (ElementSetMock1)

let test_intersection_case_insensitive _ =
  let list1 = [ "apple"; "ORANGE"; "Melon" ] in
  let list2 = [ "melon"; "cheery"; "orange" ] in
  let set1 =
    List.fold_left
      (fun acc elem -> MySetTest1.add elem acc)
      MySetTest1.empty list1
  in
  let set2 =
    List.fold_left
      (fun acc elem -> MySetTest1.add elem acc)
      MySetTest1.empty list2
  in
  let expected = "{Melon, ORANGE}" in
  let result = MySetTest1.intersection set1 set2 in
  assert_equal expected (MySetTest1.to_string result)

let suite =
  "suite"
  >::: [
         "test_intersection_case_sensitive" >:: test_intersection_case_sensitive;
         "test_intersection_case_insensitive"
         >:: test_intersection_case_insensitive;
         (* Add more test cases here *)
       ]

let () = run_test_tt_main suite
