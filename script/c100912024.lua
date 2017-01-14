--真竜剣皇マスターP
--Master Peace, the True Dracoslaying King
--Script by mercury233
function c100912024.initial_effect(c)
	--summon with s & t
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100912024,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c100912024.otcon)
	e1:SetOperation(c100912024.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--tribute check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c100912024.valcheck)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c100912024.efilter)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100912024,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCondition(c100912024.descon)
	e4:SetCost(c100912024.descost)
	e4:SetTarget(c100912024.destg)
	e4:SetOperation(c100912024.desop)
	c:RegisterEffect(e4)
end
function c100912024.otfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and not c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c100912024.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.CheckTribute then
		local mg=Duel.GetMatchingGroup(c100912024.otfilter,tp,LOCATION_ONFIELD,0,nil)
		return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=2)
			or (Duel.CheckTribute(c,1) and mg:GetCount()>=1)
			or (Duel.CheckTribute(c,2))
	else
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local mg=Duel.GetMatchingGroup(c100912024.otfilter,tp,LOCATION_ONFIELD,0,nil)
		if ft<=0 and Duel.GetTributeCount(c)<=0 then return false end
		return ft>-2 and Duel.GetTributeCount(c)+mg:GetCount()>=2
	end
end
function c100912024.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c100912024.otfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct=2
	local g=Group.CreateGroup()
	if Duel.GetTributeCount(c)<ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=mg:Select(tp,ct-Duel.GetTributeCount(c),ct-Duel.GetTributeCount(c),nil)
		g:Merge(g2)
		mg:Sub(g2)
		ct=ct-g2:GetCount()
	end
	if ct>0 and Duel.GetTributeCount(c)>=ct and mg:GetCount()>0
		and (g:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(100912024,1))) then
		local ect=ct
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then ect=ect-1 end
		ect=math.min(mg:GetCount(),ect)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g3=mg:Select(tp,1,ect,nil)
		g:Merge(g3)
		ct=ct-g3:GetCount()
	end
	if ct>0 then
		local g4=Duel.SelectTribute(tp,c,ct,ct)
		g:Merge(g4)
	end
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c100912024.valcheck(e,c)
	local g=c:GetMaterial()
	local typ=0
	local tc=g:GetFirst()
	while tc do
		typ=bit.bor(typ,bit.band(tc:GetOriginalType(),0x7))
		tc=g:GetNext()
	end
	e:SetLabel(typ)
end
function c100912024.efilter(e,te)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
		and te:IsActiveType(e:GetLabelObject():GetLabel()) and te:GetOwner()~=e:GetOwner()
end
function c100912024.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c100912024.costfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsAbleToRemoveAsCost()
end
function c100912024.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100912024.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100912024.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100912024.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100912024.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
