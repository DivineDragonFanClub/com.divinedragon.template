using System;
using System.Collections.Generic;
using UnityEngine;
using Bridge;
using App;

namespace App
{
    [DisallowMultipleComponent]
    [Serializable]
    public abstract class MapSetting : SingletonMonoBehaviour<MapSetting>
    {
        [SerializeField]
        public Bridge.MapTerrain m_MapTerrain;
        /* private List<MapObject> m_ObjectList; // 0x28
        private Dictionary<string, MapObject> m_ObjectDictionary; // 0x30
        private static MapBackupList s_BackupList; // 0x0
        private MapTerrain m_MapDevelop; // 0x38 */

        void Start()
        {
                
        }
    
        // Update is called once per frame
        void Update()
        {
            
        }
    }
}