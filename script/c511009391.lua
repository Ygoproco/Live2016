--C/C/C Water Sword of Battle
function c511009391.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--aux.AddFusionProcFun2(c,c511009391.mat_fil,aux.FilterBoolFunction(Card.IsFusionSetCard,511009400),true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c511009391.funcon)
	e0:SetOperation(c511009391.funop)
	c:RegisterEffect(e0)
	--adup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(c511009391.atktg)
	e1:SetOperation(c511009391.atkop)
	c:RegisterEffect(e1)
end
function c511009391.mat_fil(c,fc)
	local attr=c:IsAttribute(ATTRIBUTE_WATER)
	if Card.IsFusionAttribute then
		attr=c:IsFusionAttribute(ATTRIBUTE_WATER,fc)
	end
	return attr and (c:GetLevel()=5 or c:GetLevel()=6)
end


function c511009391.funcon(e,g,gc,chkfnf)
	if g==nil then return true end
	local c=e:GetHandler()
	local f2=aux.FilterBoolFunction(Card.IsFusionCode,511009400)
	local chkf=bit.band(chkfnf,0xff)
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		return (c511009391.mat_fil(gc,c) and mg:IsExists(f2,1,gc,c))
			or (f2(gc) and mg:IsExists(c511009391.mat_fil,1,gc,c)) end
	local g1=Group.CreateGroup() local g2=Group.CreateGroup() local fs=false
	local tc=mg:GetFirst()
	while tc do
		if c511009391.mat_fil(tc,c) then g1:AddCard(tc) if Auxiliary.FConditionCheckF(tc,chkf) then fs=true end end
		if f2(tc) then g2:AddCard(tc) if Auxiliary.FConditionCheckF(tc,chkf) then fs=true end end
		tc=mg:GetNext()
	end
	if chkf~=PLAYER_NONE then
		return fs and g1:IsExists(Auxiliary.FConditionFilterF2,1,nil,g2)
	else return g1:IsExists(Auxiliary.FConditionFilterF2,1,nil,g2) end
end
function c511009391.funop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local chkf=bit.band(chkfnf,0xff)
	local c=e:GetHandler()
	local f2=aux.FilterBoolFunction(Card.IsFusionCode,511009400)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if gc then
		local sg=Group.CreateGroup()
		if c511009391.mat_fil(gc,c) then sg:Merge(g:Filter(f2,gc)) end
		if f2(gc) then sg:Merge(g:Filter(c511009391.mat_fil,gc,c)) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,1,1,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=g:Filter(c511009391.FConditionFilterF2c,nil,c)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
		g1=sg:FilterSelect(tp,Auxiliary.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	local tc1=g1:GetFirst()
	sg:RemoveCard(tc1)
	local b1=c511009391.mat_fil(tc1,c)
	local b2=f2(tc1)
	if b1 and not b2 then sg:Remove(c511009391.FConditionFilterF2r1,nil,c) end
	if b2 and not b1 then sg:Remove(c511009391.FConditionFilterF2r2,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end
function c511009391.FConditionFilterF2c(c,fc)
	return c511009391.mat_fil(c,fc) or c:IsFusionCode(511009400)
end
function c511009391.FConditionFilterF2r1(c,fc)
	return c511009391.mat_fil(c,fc) and not c:IsFusionCode(511009400)
end
function c511009391.FConditionFilterF2r2(c,fc)
	return c:IsFusionCode(511009400) and not c511009391.mat_fil(c,fc)
end
function c511009391.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c511009391.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511009391.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c511009391.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c511009391.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
		local atk=g:GetSum(Card.GetAttack)
		if atk>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
		end
	end
end
function c511009391.ffilter(c,e,tp)
	return c:IsCanBeFusionMaterial() and c:IsAttribute(ATTRIBUTE_WATER) and (c:GetLevel()==5 or c:GetLevel()==6)
end
