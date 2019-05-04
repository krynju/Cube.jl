extern int render(void *adr, unsigned char *output);

struct Point {
    float position_vector[4];
};

struct Connection {
    int from;
    int to;
}__attribute__ ((aligned (4)));


struct Cube {
    struct Point vertices[8];
    float position_vector[3];
    float rotation_vector[3];
    int connections[12*2];

}__attribute__ ((aligned (16)));


int simple_fun(int val){
	return ++val;
}

void simple_fun_pointer(int *val_pointer){
	++(*val_pointer);
}

float simple_fun_args(struct Cube *str_ptr, unsigned char *output){
	
	return str_ptr->vertices[0].position_vector[0];
}

int array_arg(int *input){
	++input[1];
	return input[2];
}
