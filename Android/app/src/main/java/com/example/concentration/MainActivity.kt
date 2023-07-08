package com.example.concentration

import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.annotation.StringRes
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.State
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import androidx.navigation.compose.rememberNavController


enum class Routes {
    massFraction,
    pirsonMethod,
    molecularMass,
    molarConcentration
}

enum class CupcakeScreen(@StringRes val title: Int) {
    Start(title = R.string.app_name),
    Flavor(title = R.string.choose_flavor),
    Pickup(title = R.string.choose_pickup_date),
    Summary(title = R.string.order_summary)
}

@Composable
fun CupcakeAppBar(
    currentScreen: CupcakeScreen,
    canNavigateBack: Boolean,
    navigateUp: () -> Unit,
    modifier: Modifier = Modifier
) {
    TopAppBar(
        title = { Text(stringResource(currentScreen.title)) },
        modifier = modifier,
        navigationIcon = {
            if (canNavigateBack) {
                IconButton(onClick = navigateUp) {
                    Icon(
                        imageVector = Icons.Filled.ArrowBack,
                        contentDescription = stringResource(R.string.back_button)
                    )
                }
            }
        }
    )
}

@Composable
fun CupcakeApp(
    modifier: Modifier = Modifier,
    viewModel: OrderViewModel = viewModel(),
    navController: NavHostController = rememberNavController()
) {
    val backStackEntry by navController.currentBackStackEntryAsState()
    val  currentScreen = CupcakeScreen.valueOf(
        backStackEntry?.destination?.route ?: CupcakeScreen.Start.name
    )
}








class OrderViewModel : ViewModel() {
}




class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        var formulas = mutableListOf<String>("bezkoder.com", "programming", "tutorial")
        setContent {
            MaterialTheme {
                MainListScreen(formulas = formulas)
            }
        }
    }
}

@Composable
fun MainListScreen(formulas: List<String>) {
    val context = LocalContext.current
    LazyColumn(modifier = Modifier.padding(vertical = 4.dp)) {
        items(items = formulas) { formula ->
            FormulaCellView(formula = formula) {
                Toast.makeText(context, it, Toast.LENGTH_SHORT).show()
            }
        }
    }
}

@Composable
private fun FormulaCellView(formula: String, onClick: (title: String) -> Unit) {
    val title = "${formula}"
    Card(
        backgroundColor = MaterialTheme.colors.primary,
        modifier = Modifier
            .padding(vertical = 4.dp, horizontal = 8.dp)
            .clickable { onClick(title) }
    ) {
        Row(modifier = Modifier
            .padding(12.dp)
            .fillMaxWidth()) {
            Text(text = title)
        }
    }
}

@Composable
fun Greeting(text: State<String>,
             onValueChange: (String) -> Unit) {
    OutlinedTextField(
        value = text.value,
        onValueChange = onValueChange
    )
}

class EvenOdd() {
    fun check(value: Int): String {
        return if (value % 2 == 0) "even" else "odd"
    }
}

@Composable
fun ClickCounter(
    counterValue: Int,
    onCounterClick: () -> Unit
) {
    val evenOdd = remember {
        EvenOdd()
    }
    Text(
        text = "Clicks: $counterValue ${evenOdd.check(counterValue)}",
        modifier = Modifier
            .clickable(onClick = onCounterClick)
            .fillMaxWidth()
            .height(100.dp)
    )
}

//@Preview(showBackground = true)
//@Composable
//fun DefaultPreview() {
//    ConcentrationTheme {
//        Greeting("Android")
//    }
//}