using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace App {
    public class Curve {
        public enum Type {
            Linear = 0,
            Accel = 1,
            Decel = 2,
            AccelDecel = 3,
            DecelAccel = 4,
            LinearDecel = 5,
            LinearAccel = 6,
            DecelLinear = 7,
            AccelLinear = 8,
        }
    }
}