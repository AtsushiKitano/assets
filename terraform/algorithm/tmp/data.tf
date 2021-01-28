locals {

  test = {
    test  = "value"
    test2 = "value2"
  }

  abc = {
    shohoku = {
      sakuragi = 10
      rukawa   = 11
      akagi    = 4
      mitsui   = 18
      miyagi   = 7
    }

    ryonan = {
      sendo  = 8
      uodumi = 4
    }
  }
}

output "test" {
  value = {
    for k, v in local.test : k => k
  }
}

output "demo" {
  value = merge(local.test, lookup(local.abc, "kainan", null))
}
