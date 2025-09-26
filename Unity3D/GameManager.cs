using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{   
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.name == "Player")
        {
            UnityEngine.SceneManagement.SceneManager.LoadScene("SampleScene");
        }
    }
}
