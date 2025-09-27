using UnityEngine;
using System.Collections;

namespace App
{
    public class SingletonMonoBehaviour<T> : MonoBehaviour where T : MonoBehaviour
    {
        private static T s_Instance;
    
        public static T Instance {
            get {
                if (s_Instance == null) {
                    s_Instance = (T)FindObjectOfType (typeof(T));
     
                    if (s_Instance == null) {
                        s_Instance = new GameObject(typeof(T).ToString()).AddComponent<T>();
                    }
                }
     
                return s_Instance;
            }
        }
    }
}