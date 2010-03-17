//
//  worldViewController.m
//  TunifyIPhone
//
//  Created by thesis on 17/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "worldViewController.h"
#import "mapViewController.h"
#import "musicViewController.h"
#import "ConstantsAndMacros.h"
#import "OpenGLCommon.h"


@implementation worldViewController

static Vertex3D *normals;

@synthesize strPubName;
@synthesize glView;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void) btnPubs_clicked:(id)sender {
	
	// Show the tab bar (because the pubs view needs it)
	if ( self.tabBarController.view.subviews.count >= 2 )
    {
        UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
		
		[view sizeToFit];
		tabBar.hidden = FALSE;
	}
	
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) btnMusic_clicked:(id)sender {
	musicViewController *mvc = [[musicViewController alloc] initWithNibName:@"musicView" bundle:[NSBundle mainBundle]];
	mvc.strPubName = strPubName;
	[self.navigationController pushViewController:mvc animated:YES];
	[mvc release];
	mvc = nil;
}

- (IBAction) capturedToggleChanged:(id)sender {
	
	if(capturedToggle.selectedSegmentIndex == 0) {
		mapViewController *mvc = [[mapViewController alloc] initWithNibName:@"mapView" bundle:[NSBundle mainBundle]];
		mvc.strPubName = strPubName;
		[self.navigationController pushViewController:mvc animated:YES];
		[mvc release];
		mvc = nil;
	}
}


-(Vertex3D *) vertexNormals:(Vertex3D*)vertices nVertices:(int)nVertices faces:(GLubyte*)arrowFaces nFaces:(int)nFaces 
{
	
	
	Vector3D *surfaceNormals = calloc(nFaces, sizeof(Vector3D));
	
	// Calculate the surface normal for each triangle
	
	for (int i = 0; i < nFaces; i++)
	{
		Vertex3D vertex1 = vertices[arrowFaces[(i*3)]];
		Vertex3D vertex2 = vertices[arrowFaces[(i*3)+1]];
		Vertex3D vertex3 = vertices[arrowFaces[(i*3)+2]];
		Triangle3D triangle = Triangle3DMake(vertex1, vertex2, vertex3);
		Vector3D surfaceNormal = Triangle3DCalculateSurfaceNormal(triangle);
		Vector3DNormalize(&surfaceNormal);
		surfaceNormals[i] = surfaceNormal;
	}
	
	Vertex3D *normals = calloc(nVertices, sizeof(Vertex3D));
	
	for (int i = 0; i < nVertices; i++)
	{
		int faceCount = 0;
		for (int j = 0; j < nFaces; j++)
		{
			BOOL contains = NO;
			for (int k = 0; k < 3; k++)
			{
				if (arrowFaces[(j * 3) + k] == i)
					contains = YES;
			}
			if (contains)
			{
				faceCount++;
				normals[i] = Vector3DAdd(normals[i], surfaceNormals[j]);
			}
		}
		
		normals[i].x /= (GLfloat)faceCount;
		normals[i].y /= (GLfloat)faceCount;
		normals[i].z /= (GLfloat)faceCount;
	}
	return normals;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Hide the tab bar
	if ( self.tabBarController.view.subviews.count >= 2 )
    {
        UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
		
		view.frame = CGRectMake(0, 0, 320, 480 );     
		tabBar.hidden = TRUE;
        
		// Note: These views must not be released because they are still required.
    }
	
	
	self.navigationItem.title = strPubName;
	
	// Create the left bar button item
	UIBarButtonItem *pubsBarButtonItem = [[UIBarButtonItem alloc] init];
	pubsBarButtonItem.title = @"Pubs";
	pubsBarButtonItem.target = self;
	pubsBarButtonItem.action = @selector(btnPubs_clicked:);
	self.navigationItem.leftBarButtonItem = pubsBarButtonItem;
	[pubsBarButtonItem release];
	
	// Create the right bar button item
	UIBarButtonItem *musicBarButtonItem = [[UIBarButtonItem alloc] init];
	musicBarButtonItem.title = @"Music";
	musicBarButtonItem.target = self;
	musicBarButtonItem.action = @selector(btnMusic_clicked:);
	self.navigationItem.rightBarButtonItem = musicBarButtonItem;
	[musicBarButtonItem release];
	
	
	NSLog(@"Creating glview");
	glView = [[GLView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
	glView.delegate = self;
	//self.view = glView;
	[self.view addSubview:glView];
	NSLog(@"glView created");
	
	
	static const Vertex3D vertices[]= {
		
		// pointer sides
		{0, 0.0f, -1.0f},					// 0
		{0, -0.3f, -1.0f},					// 1
		{-0.5f, 0.0f, -0.2f},				// 2
		{-0.5f, -0.3f, -0.2f},				// 3
		{0.5f, 0.0f, -0.2f},				// 4
		{0.5f, -0.3f, -0.2f},				// 5
		
		// pointer roof
		{0, 0.0f, -1.0f},					// 6
		{-0.5f, 0.0f, -0.2f},				// 7
		{0.5f, 0.0f, -0.2f},				// 8
		
		// box left side	
		{-0.15f, 0.0f, -0.2f},				// 9
		{-0.15f, -0.3f, -0.2f},				// 10
		{-0.15f, 0.0f, 1.5f},				// 11
		{-0.15f, -0.3f, 1.5f},				// 12
		
		// box right side
		{0.15f, 0.0f, -0.2f},				// 13
		{0.15f, -0.3f, -0.2f},				// 14
		{0.15f, 0.0f, 1.5f},				// 15
		{0.15f, -0.3f, 1.5f},				// 16
		
		// box closest side
		{0.15f, 0.0f, 1.5f},				// 17
		{0.15f, -0.3f, 1.5f},				// 18
		{-0.15f, 0.0f, 1.5f},				// 19
		{-0.15f, -0.3f, 1.5f},				// 20
		
		// box top side
		{0.15f, 0.0f, -0.2f},				// 21
		{-0.15f, 0.0f, -0.2f},				// 22
		{0.15f, 0.0f, 1.5f},				// 23
		{-0.15f, 0.0f, 1.5f}				// 24
		
    };
    
    static const GLubyte arrowFaces[] = {
		// pointer sides
		0, 2, 1,
		2, 1, 3,
		0, 4, 5,
		0, 5, 1,
		4, 2, 3,
		4, 3, 5,
		
		// pointer roof
		6, 7, 8,
		
		// box left side
		9, 11, 12,
		9, 12, 10,
		
		// box right side
		13, 15, 14,
		15, 16, 14,
		
		// box closest side
		17, 19, 20,
		17, 18, 20,
		
		// box top side
		21, 23, 24,
		21, 22, 24,
    };
	
	
	
	
	
	if (normals == NULL) {
		int nVertices = sizeof(vertices) / sizeof(Vertex3D);
		int nFaces = sizeof(arrowFaces) / (sizeof(GLubyte) * 3);
		normals = [self vertexNormals:vertices nVertices:nVertices faces:arrowFaces nFaces:nFaces];
	}
	 
	
	glView.animationInterval = 1.0 / kRenderingFrequency;
	[glView startAnimation];

	
	/*
	glView = [[EAGLView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	UILabel* distanceLeft = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 300, 20)];
	distanceLeft.text = @"254 meters to go";
	distanceLeft.textAlignment = UITextAlignmentCenter;
	distanceLeft.font = [UIFont systemFontOfSize:18];
	distanceLeft.adjustsFontSizeToFitWidth = NO;
	distanceLeft.textColor = [UIColor blackColor];
	distanceLeft.backgroundColor = [UIColor clearColor];
	[glView addSubview:distanceLeft];
	[distanceLeft release];
	
	self.view = glView;
	*/
}


- (void)drawView:(UIView *)theView
{
	
	NSLog(@"Drawing view");
    static GLfloat rot = 0.0;
    
	static const Vertex3D vertices[]= {
		
		// pointer sides
		{0, 0.0f, -1.0f},					// 0
		{0, -0.3f, -1.0f},					// 1
		{-0.5f, 0.0f, -0.2f},				// 2
		{-0.5f, -0.3f, -0.2f},				// 3
		{0.5f, 0.0f, -0.2f},				// 4
		{0.5f, -0.3f, -0.2f},				// 5
		
		// pointer roof
		{0, 0.0f, -1.0f},					// 6
		{-0.5f, 0.0f, -0.2f},				// 7
		{0.5f, 0.0f, -0.2f},				// 8
		
		// box left side	
		{-0.15f, 0.0f, -0.2f},				// 9
		{-0.15f, -0.3f, -0.2f},				// 10
		{-0.15f, 0.0f, 1.5f},				// 11
		{-0.15f, -0.3f, 1.5f},				// 12
		
		// box right side
		{0.15f, 0.0f, -0.2f},				// 13
		{0.15f, -0.3f, -0.2f},				// 14
		{0.15f, 0.0f, 1.5f},				// 15
		{0.15f, -0.3f, 1.5f},				// 16
		
		// box closest side
		{0.15f, 0.0f, 1.5f},				// 17
		{0.15f, -0.3f, 1.5f},				// 18
		{-0.15f, 0.0f, 1.5f},				// 19
		{-0.15f, -0.3f, 1.5f},				// 20
		
		// box top side
		{0.15f, 0.0f, -0.2f},				// 21
		{-0.15f, 0.0f, -0.2f},				// 22
		{0.15f, 0.0f, 1.5f},				// 23
		{-0.15f, 0.0f, 1.5f}				// 24
		
    };
    
    static const Color3D colors[] = {
		// pointer sides
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		
		// pointer roof
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		
		//box left side
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		
		//box right side
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		
		//box closest side
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		
		//box top side
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0},
		{1.0, 0.6, 0.2, 1.0}
		 
    };
    
    static const GLubyte arrowFaces[] = {
		// pointer sides
		0, 2, 1,
		2, 1, 3,
		0, 4, 5,
		0, 5, 1,
		4, 2, 3,
		4, 3, 5,
		
		// pointer roof
		6, 8, 7,
		
		// box left side
		9, 11, 12,
		9, 12, 10,
		
		// box right side
		13, 15, 14,
		15, 16, 14,
		
		// box closest side
		17, 19, 20,
		17, 18, 20,
		
		// box top side
		21, 23, 24,
		21, 22, 24,
    };
    
    glLoadIdentity();
    glTranslatef(0.0f,0.0f,-3.0f);
	glScalef(0.5f, 0.5f, 0.5f);
    glRotatef(45,1.0f,0.0f,0.0f);
	glRotatef(rot, 0.0f, 1.0f, 0.0f);
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_NORMAL_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    glColorPointer(4, GL_FLOAT, 0, colors);
	glNormalPointer(GL_FLOAT, 0, normals);

	
    glDrawElements(GL_TRIANGLES, 45, GL_UNSIGNED_BYTE, arrowFaces);
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_NORMAL_ARRAY);
	
    static NSTimeInterval lastDrawTime;
    if (lastDrawTime)
    {
        NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
        rot+=50 * timeSinceLastDraw;                
    }
    lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
	
	//int nVertices = sizeof(vertices) / sizeof(Vertex3D);
	//int nFaces = sizeof(arrowFaces) / (sizeof(GLubyte) * 3);
	//normals = [self vertexNormals:vertices nVertices:nVertices faces:arrowFaces nFaces:nFaces];
	
	NSLog(@"View drawn");
    
}
-(void)setupView:(GLView*)view
{
	
	const GLfloat zNear = 0.01, zFar = 1000.0, fieldOfView = 45.0; 
	GLfloat size; 
	glEnable(GL_DEPTH_TEST);
	glMatrixMode(GL_PROJECTION); 
	size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0); 
	CGRect rect = view.bounds; 
	glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / 
			   (rect.size.width / rect.size.height), zNear, zFar); 
	glViewport(0, 0, rect.size.width, rect.size.height);  
	glMatrixMode(GL_MODELVIEW);
	
	// Enable normals
	glEnableClientState(GL_NORMAL_ARRAY);
	
	// Create the materials
	GLfloat ambientAndDiffuse[] = {0.0, 0.1, 0.9, 1.0};
    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, ambientAndDiffuse);
    GLfloat specular[] = {0.3, 0.3, 0.3, 1.0};
    glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, specular);
    glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, 25.0);
	
	// Enable lighting
    glEnable(GL_LIGHTING);
	
    // Turn the first light on
    glEnable(GL_LIGHT0);
    
    // Define the ambient component of the first light
    const GLfloat light0Ambient[] = {0.1, 0.1, 0.1, 1.0};
    glLightfv(GL_LIGHT0, GL_AMBIENT, light0Ambient);
    
    // Define the diffuse component of the first light
    const GLfloat light0Diffuse[] = {0.7, 0.7, 0.7, 1.0};
    glLightfv(GL_LIGHT0, GL_DIFFUSE, light0Diffuse);
    
    // Define the specular component and shininess of the first light
    const GLfloat light0Specular[] = {0.7, 0.7, 0.7, 1.0};
    const GLfloat light0Shininess = 0.4;
    glLightfv(GL_LIGHT0, GL_SPECULAR, light0Specular);
    
    
    // Define the position of the first light
    const GLfloat light0Position[] = {0.0, 5.0, 5.0, 0.0}; 
    glLightfv(GL_LIGHT0, GL_POSITION, light0Position); 
    
    // Define a direction vector for the light, this one points right down the Z axis
    const GLfloat light0Direction[] = {0.0, 0.0, -1.0};
    glLightfv(GL_LIGHT0, GL_SPOT_DIRECTION, light0Direction);
	
    // Define a cutoff angle. This defines a 90° field of vision, since the cutoff
    // is number of degrees to each side of an imaginary line drawn from the light's
    // position along the vector supplied in GL_SPOT_DIRECTION above
    glLightf(GL_LIGHT0, GL_SPOT_CUTOFF, 45.0);
	
	glLoadIdentity(); 
	glClearColor(1.0, 1.0, 1.0, 1.0);
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[strPubName release];
	[glView release];
    [super dealloc];
}


@end
