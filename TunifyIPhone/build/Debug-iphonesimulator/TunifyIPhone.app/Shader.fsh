//
//  Shader.fsh
//  iphoneopengltest
//
//  Created by Elegia on 17/03/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
	gl_FragColor = colorVarying;
}
