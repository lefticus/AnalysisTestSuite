#include <utility>


struct Object {
  void doSomething() {}
};

void take(Object &&) { }

void use_after_move()
{
  Object o;
  take(std::move(o));
  o.doSomething(); // use of local after move
}

int main()
{
  use_after_move();
}
