--Scripted by Eerie Code
--Bloom Prima the Melodious Choir
function c700000029.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c700000029.mfilter1,c700000029.mfilter2,true)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c700000029.matcheck)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end

function c700000029.mfilter1(c)
	local code=c:GetCode()
	return code==62895219 or code==14763299
	--return (c:IsCode(62895219) or c:IsCode(6812)) and mg:IsExists(c700000029.mfilter2,1,c)
end
function c700000029.mfilter2(c)
	return c:IsSetCard(0x9b)
end
function c700000029.fscon(e,mg,gc)
	if mg==nil then return true end
	if gc then return false end
	return mg:IsExists(c700000029.mfilter1,1,nil,mg)
end
function c700000029.fsop(e,tp,eg,ep,ev,re,r,rp,gc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=eg:FilterSelect(tp,c700000029.mfilter1,1,1,nil,eg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=eg:FilterSelect(tp,c700000029.mfilter2,1,63,g1:GetFirst())
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end
function c700000029.matcheck(e,c)
	local ct=c:GetMaterialCount()
	local ae=Effect.CreateEffect(c)
	ae:SetType(EFFECT_TYPE_SINGLE)
	ae:SetCode(EFFECT_UPDATE_ATTACK)
	ae:SetValue(ct*300)
	ae:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(ae)
end